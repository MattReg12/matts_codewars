class InvalidBond < StandardError
# throw if you encounter a case where atom exceeeds valence number or is bound to itself
# when exception thrown while it still has args left to handle, the modifications resulting
# from previous valid operations must be kept
end

class LockedMolecule < StandardError
  #thrown when attempt to modify after locked
end


class Molecule
  attr_reader :name, :reader

  def initialize(name = '')
    @name = name
    @branches = []
    @atoms = []
    @locked = false
    @atom_count = 0
  end

  def formula
    raise LockedMolecule unless @locked

    ids = @branches.flatten.map(&:element)
    counts = ids.tally
    counts = remove_ones(counts).to_a
    counts = counts.map(&:join)
    counts = counts.partition { |elem| ['H', 'C', 'O'].include?(elem[0]) }
    counts.each(&:sort!)
    counts.flatten.join
  end

  def molecular_weight
    raise LockedMolecule unless @locked

    atoms.map(&:weight).sum
  end

  # Adds new 'branches' to the current molecule.
  # Args are the new carbon elements to be added
  def brancher(*carbons)
    carbons.each do |carbon|
      branch = []
      carbon.times { branch << add_atom('C') }
      @branches << branch
    end
    bond_carbons
    self
  end

  def bounder(*arrs)
    arrs.each do |arr|
      atom_1 = @branches[arr[1] - 1][arr[0] - 1]
      atom_2 = @branches[arr[3] - 1][arr[2] - 1]
      atom_1.add_bond(atom_2)
      atom_2.add_bond(atom_1)
    end
    self
  end

  def mutate(*arrs)
    arrs.each do |arr|
      atom = @branches[arr[1] - 1][arr[0] - 1]
      atom.mutate(arr[2])
    end
    #[nc, nb, elt]  -- mutates the carbon (nc) in the branch (nb) to the chemical element (elt) given as string
    #id of atom instance stays the same
    self
  end

  def add(*arrs)
    arrs.each do |arr|
      carbon_i, branch_i, elem = arr
      carbon = @branches[branch_i - 1][carbon_i - 1]
      atom.add_bond(elem)
    end
    self
    # Atoms added this way are not considered as being part of the branch they are bounded to
    #and aren't considered a new branch of the molecule.
  end

  def add_chaining(*args)
    # if error occurs at any point, all of its atoms have to be removed from the instance
    # (nc, nb, elt1, elt2, ...)
    # adds on the carbon (nc) in the branch (nb) a chaing with all the provide elements in the specified
    # order. m.add_chaining(2, 5, "N", "C", "C", "Mg", "Br") will add the chain ...
    #-N-C-C-Mg-Br to the atom number 2 in the branch 5.
    # not considered a new branch of the molecule
  end

  def closer
    bond_hydrogens
    @locked = true
    self
  end

  def unlock
    #makes molecule mutable
    #removes hydrogens and any empty branches
    #throw EmptyMolecule exception if no branches left
    #the ids of the remaining atoms must be continous again starting at 1
    # if you end up with atoms that arent connected to the branches of the unlocked molecule, keep them anyways
    #must be modifiable again in any manner
  end

  private

  attr_accessor :locked
  attr_writer :atom_count

  # creates atom to be added to element and increments atom_count counter
  def add_atom(elem)
    @atom_count +=1
    atom = Atom.new(elem, @atom_count)
    @atoms << atom
    atom
  end

  def bond_hydrogens
    @branches.each do |branch|
      branch.size.times do |atom_i|
        atom = branch[atom_i]
        empty_bonds = atom.valence - atom.bonds.size
        empty_bonds.times do
          h = add_atom('H')
          branch << h
          atom.bonds << h
          h.bonds << atom
        end
      end
    end
  end

  def bond_carbons
    @branches.each do |branch|
      next if branch.size <= 1
      branch.each_with_index do |carbon, i|
        if i.zero?
          carbon.bonds << branch[i + 1]
        elsif i == (branch.size - 1)
          carbon.bonds << branch[i - 1]
        else
          carbon.bonds << branch[i - 1]
          carbon.bonds << branch[i + 1]
        end
      end
    end
  end

  def remove_ones(hash)
    hash.each_key do |key|
      hash[key] = '' if hash[key] == 1
    end
  end
end

# Instances of this class represent atoms in a specific Molecule
# instance and the bonds they hold with other Atom instances.
class Atom
  WEIGHT =  { 'H' => 1.0, 'B' => 10.8, 'C' => 12.0, 'N' => 14.0, 'O' => 16.0,
              'F' => 19.0, 'Mg' => 24.3, 'P' => 31.0, 'S' => 32.1,
              'Cl' => 35.5, 'Br' => 80.0 }

  VALENCE =  { 'H' => 1, 'B' => 3, 'C' => 4, 'N' => 3, 'O' => 2,
              'F' => 1, 'Mg' => 2, 'P' => 3, 'S' => 2,
              'Cl' => 1, 'Br' => 1 }

  attr_accessor :element
  attr_reader :bonds, :weight, :valence, :id

  def initialize(elt, id=1)
    @element = elt
    @weight = WEIGHT[elt]
    @valence = VALENCE[elt]
    @bonds = []
    @id = id
  end

  def hash
    self.id
  end

  def ==(other)
    self.id == other.id
  end

  def eql?(other)
    self == other
  end

  def to_s
    if bonds.empty?
      "Atom(#{element}.#{id})"
    else
      "Atom(#{element}.#{id}: #{bonds_to_s})"
    end
  end

  def add_bond(other)
    raise InvalidBond if eql?(other) || (bonds.size == valence)

    @bonds << other
  end

  def mutate(elt)
    raise InvalidBond if VALENCE[elt] < bonds.size

    self.element = elt
    self.weight = WEIGHT[elt]
    self.valence = VALENCE[elt]
  end

  private

  attr_writer :weight, :valence

  def bonds_to_s
    str = bonds.map do |bond|
      if bond.element == 'H'
        'H'
      else
        "#{bond.element}#{bond.id}"
      end
    end
    arr = bond_sort(str).join(',')
  end

  def bond_sort(str)
    arr = Array.new(3) {[]}
    str.each do |elem|
      case elem[0]
      when 'H' then arr[2] << elem
      when 'C' then arr[0] << elem
      when '0' then arr[0] << elem
      else arr[1] << elem
      end
    end
    arr.delete_if(&:empty?)
    arr.each { |sub_arr| sub_arr.sort_by! { |str| str[1..-1].to_i } }
  end
end
