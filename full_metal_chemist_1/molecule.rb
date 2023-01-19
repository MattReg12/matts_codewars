=begin

branch - represents a chain of atoms bound together. When a branch is
created, all of its atoms are carbons. Each branch of the molecule is ID'd
by a number that matches its creation order.


=end




class Molecule
    attr_reader :name

  def initialize(name = '')
    @name = name
    @branches = []
  end

  def formula
    #gives the raw formula of the final moleculs as a string
  end

  def moelecular_weight
    # returns a double value in g/mol
  end

  def atoms
    # gives list of atoms appended order of their creation
  end

  def brancher(*ints)
    #postive integers
    #adds new 'branches' to the current molecule
    #each arg gives the number of carbons on the new brach
  end

  def bounder(*arrs)
    #creates new bounds between 2 atoms of existing branches
    #each arr gives 4 ints
    # [c1, b1, c2, b2]   carbon and branch of first, carbon and branch of 2nd
    #positions are 1 indexed. (1, 1, 5, 3) means bind first carbon on 1st branch to
    #5th carbon on 3rd branch
    # only positive ints
  end

  def mutate(*arrs)
    # 1 indexed
    #[nc, nb, elt]  -- mutates the carbon (nc) in the branch (nb) to the chemical element (elt) given as string
    #id of atom instance stays the same
  end

  def add(*arrs)
    # [nc, nb, elt] - adds a new atom (elt) on the carbon (nc) in the branch (nb)
    # Atoms added this way are not considered as being part of the branch they are bounded to
    #and aren't considered a new branch of the molecule.
  end

  def add_chaining(*args)
    # (nc, nb, elt1, elt2, ...)
    # adds on the carbon (nc) in the branch (nb) a chaing with all the provide elements in the specified
    # order. m.add_chaining(2, 5, "N", "C", "C", "Mg", "Br") will add the chain ...
    #-N-C-C-Mg-Br to the atom number 2 in the branch 5.
    # not considered a new branch of the molecule
  end

  def closer
    #finalizes molecule instance. adding missing hydrogens and locking the object
  end

  def unlock
    #makes molecule mutable
    #removes hydrogens and any empty branches
    #throw EmptyMolecule exception if no branches left
    #
  end

end




class Atom


end
