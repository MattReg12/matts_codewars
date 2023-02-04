require 'set'

class InvalidBond < StandardError
end

class LockedMolecule < StandardError
end

class UnlockedMolecule < StandardError
end

class Molecule
attr_reader :name, :atoms, :locked

  def initialize(name = '')
    @name = name
    @branches = []
    @atoms = []
    @locked = false
    @atom_count = 0
  end

  def formula
    raise UnlockedMolecule unless locked

    ids = atoms.partition { |atom| ['H', 'C', 'O'].include?(atom.element) }
    ids.each { |atom_arr| atom_arr.sort_by!(&:element) }
    ids = ids.flatten.uniq { |atom| atom.element }
    ids.each_with_object('') do |atom, form|
      count = atoms.count { |atm| atom.element == atm.element}
      if count == 1
        form << atom.element
      else form << (atom.element + count.to_s)
      end
    end
  end

  def molecular_weight
    raise UnlockedMolecule unless locked

    atoms.map(&:weight).sum
  end

  def brancher(*carbons)
    raise LockedMolecule if locked

    p ['brancher', carbons]
    carbons.each do |carbon|
      branch = []
      carbon.times { branch << add_atom('C') }
      chain_bonder(branch)
      @branches << branch
    end
    self
  end

  def bounder(*arrs)
    raise LockedMolecule if locked

    p self
    p ['bounder', arrs]
    arrs.each do |carbon_i1, branch_i1, carbon_i2, branch_i2|
      atom_1 = @branches[branch_i1 - 1][carbon_i1 - 1]
      atom_2 = @branches[branch_i2 - 1][carbon_i2 - 1]
      atom_1.add_bond(atom_2)
    end
    p self
  end

  def mutate(*arrs)
    raise LockedMolecule if locked

    p self
    p ['mutate', arrs]
    arrs.each do |carbon_i, branch_i, elt|
      atom = @branches[branch_i - 1][carbon_i - 1]
      atom.mutate(elt)
    end
    p self
  end

  def add(*arrs)
    raise LockedMolecule if locked

    p ['add', arrs]
    arrs.each do |carbon_i, branch_i, elem|
      base = @branches[branch_i - 1][carbon_i - 1]
      raise InvalidBond if base.fully_bonded?

      atom = add_atom(elem)
      base.add_bond(atom)
    end
    self
  end

  def add_chaining(carbon_i, branch_i, *elts)
    raise LockedMolecule if locked
    p ['add_chaining', carbon_i, branch_i, elts]
    raise InvalidBond if chained_monovalence?(elts)

    base = @branches[branch_i - 1][carbon_i - 1]
    unless base.fully_bonded?
      elts.map! { |elt| add_atom(elt) }
      elts.prepend(base)
      chain_bonder(elts)
    end
    self
  end

  def closer
    raise LockedMolecule if locked
    puts 'locking'
    bond_hydrogens
    @locked = true
    self
  end

  def unlock
    @locked = false
    unbond_hydrogens

    #removes hydrogens and any empty branches
    #throw EmptyMolecule exception if no branches left
    #the ids of the remaining atoms must be continous again starting at 1
    # if you end up with atoms that arent connected to the branches of the unlocked molecule, keep them anyways
    #must be modifiable again in any manner
    self
  end

  def inspect
    @atoms.map(&:to_s).join
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
    atoms.each do |atom|
      empty_bonds = atom.valence - atom.bonds.size
      empty_bonds.times { atom.add_bond(add_atom('H')) }
    end
  end

  def unbond_hydrogens
    hydrogens = atoms.select { |atom| atom.element == 'H' }

  end

  def chain_bonder(chain)
    last_i = chain.size - 1
    chain.each_with_index do |atom, i|
      atom.add_bond(chain[i + 1]) unless i == last_i
    end
  end

  def chained_monovalence?(elts)
    elts[0..-2].any? { |elt| Atom.new(elt).valence == 1 }
  end

  def update_ids

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

  def add_bond(other)
    raise InvalidBond if [eql?(other), bonds.size == valence, other.bonds.size == valence].any?

    other.bonds << self
    @bonds << other
  end

  def mutate(elt)
    raise InvalidBond if VALENCE[elt] < bonds.size

    self.element = elt
    self.weight = WEIGHT[elt]
    self.valence = VALENCE[elt]
  end

  def hash()
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

  def fully_bonded?
    bonds.size == valence
  end

  private

  attr_writer :weight, :valence

  def bonds_to_s
    sorted = element_sort
    sorted.each { |sub_arr| sub_arr.sort_by! { |atom| [atom.element, atom.id] } }
    sorted.flatten!.map! do |atom|
      atom.element == 'H' ? "#{atom.element}" : "#{atom.element}#{atom.id}"
    end
    sorted.join(',')
  end

  def element_sort
    arr = Array.new(3) {[]}
    bonds.each do |atom|
      case atom.element
      when 'H' then arr[2] << atom
      when 'C' then arr[0] << atom
      when 'O' then arr[0] << atom
      else arr[1] << atom
      end
    end
    arr
  end
end
