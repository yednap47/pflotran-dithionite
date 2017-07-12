module Reaction_Sandbox_Dithionite_exp_kat_class

! Id: Reaction_Sandbox_Dithionite_exp_kat, Mon 24 Apr 2017 12:11:58 PM MDT pandeys !
! Created by Sachin Pandey, LANL
! Description: Use bimolecular reaction with Paul formulation for stoichiometry:
!    xH^+ + 3S2O4^-2 + 3H2O -> SO3^-2 + 2HS^- + 3SO4^-2 + (4+x)H^+ 
!------------------------------------------------------------------------------

! 1. Change all references to "Dithionite_exp_kat" as desired to rename the module and
!    and subroutines within the module.

  use Reaction_Sandbox_Base_class

  use Global_Aux_module
  use Reactive_Transport_Aux_module

  use PFLOTRAN_Constants_module

  implicit none

  private

#include "petsc/finclude/petscsys.h"

! 2. Add module variables here.  Note that one must use the PETSc data types
!    PetscInt, PetscReal, PetscBool to declare variables of type integer
!    float/real*8, and logical respectively.  E.g.
!
! PetscReal, parameter :: formula_weight_of_water = 18.01534d0

  type, public, &
    extends(reaction_sandbox_base_type) :: reaction_sandbox_dithionite_exp_kat_type
! 3. Add variables/arrays associated with new reaction.
    character(len=MAXWORDLENGTH) :: name_spec_s2o4 ! S2O4--
    character(len=MAXWORDLENGTH) :: name_spec_so3 ! SO3--
    character(len=MAXWORDLENGTH) :: name_spec_hs  ! HS- (bisulfide)
    character(len=MAXWORDLENGTH) :: name_spec_so4  ! SO4--
    character(len=MAXWORDLENGTH) :: name_spec_h ! H+

    PetscInt :: id_spec_s2o4, id_spec_so3, id_spec_hs, id_spec_so4, id_spec_h
    PetscReal :: rate_constant, exp_h, exp_s2o4, eps
  contains
    procedure, public :: ReadInput => Dithionite_exp_katRead
    procedure, public :: Setup => Dithionite_exp_katSetup
    procedure, public :: Evaluate => Dithionite_exp_katReact
    procedure, public :: UpdateKineticState => Dithionite_exp_katKineticState
    procedure, public :: Destroy => Dithionite_exp_katDestroy
  end type reaction_sandbox_dithionite_exp_kat_type

  public :: Dithionite_exp_katCreate

contains

! ************************************************************************** !

function Dithionite_exp_katCreate()
  !
  ! Allocates dithionite_exp_kat reaction object.
  !
  ! Author: Sachin Pandey 
  ! Date: 07/11/17 
  !

  implicit none

  class(reaction_sandbox_dithionite_exp_kat_type), pointer :: Dithionite_exp_katCreate

! 4. Add code to allocate object and initialized all variables to zero and
!    nullify all pointers. E.g.
  allocate(Dithionite_exp_katCreate)
  Dithionite_exp_katCreate%name_spec_s2o4 = ''
  Dithionite_exp_katCreate%name_spec_so3 = ''
  Dithionite_exp_katCreate%name_spec_hs = ''
  Dithionite_exp_katCreate%name_spec_so4 = ''
  Dithionite_exp_katCreate%name_spec_h = ''
  Dithionite_exp_katCreate%id_spec_s2o4 = 0
  Dithionite_exp_katCreate%id_spec_so3 = 0
  Dithionite_exp_katCreate%id_spec_hs = 0
  Dithionite_exp_katCreate%id_spec_so4 = 0
  Dithionite_exp_katCreate%id_spec_h = 0
  Dithionite_exp_katCreate%rate_constant = 0.d0
  Dithionite_exp_katCreate%exp_h = 0.d0
  Dithionite_exp_katCreate%exp_s2o4 = 0.d0
  Dithionite_exp_katCreate%eps = 0.d0

  nullify(Dithionite_exp_katCreate%next)

end function Dithionite_exp_katCreate

! ************************************************************************** !

subroutine Dithionite_exp_katRead(this,input,option)
  !
  ! Reads input deck for dithionite_exp_kat reaction parameters (if any)
  !
  ! Author: Sachin Pandey
  ! Date: 04/24/17
  !

#include "petsc/finclude/petscsys.h"
  use petscsys
  use Option_module
  use String_module
  use Input_Aux_module
  use Units_module, only : UnitsConvertToInternal

  implicit none

  class(reaction_sandbox_dithionite_exp_kat_type) :: this
  type(input_type), pointer :: input
  type(option_type) :: option

  PetscInt :: i
  character(len=MAXWORDLENGTH) :: word, internal_units

  do
    call InputReadPflotranString(input,option)
    if (InputError(input)) exit
    if (InputCheckExit(input,option)) exit

    call InputReadWord(input,option,word,PETSC_TRUE)
    call InputErrorMsg(input,option,'keyword', &
                       'CHEMISTRY,REACTION_SANDBOX,DITHIONITE_EXP_KAT')
    call StringToUpper(word)

    select case(trim(word))

      ! Dithionite_exp_kat Input:

      ! CHEMISTRY
      !   ...
      !   REACTION_SANDBOX
      !   : begin user-defined input
      !     DITHIONITE_EXP_KAT
      !       DITHIONITE_EXP_KAT_INTEGER 1
      !       DITHIONITE_EXP_KAT_INTEGER_ARRAY 2 3 4
      !     END
      !   : end user defined input
      !   END
      !   ...
      ! END

! 5. Add case statement for reading variables.  E.g.
! 6. Read the variable
! 7. Inform the user of any errors if not read correctly.
      case('RATE_CONSTANT')
        call InputReadDouble(input,option,this%rate_constant)
        call InputErrorMsg(input,option,'RATE_CONSTANT', &
                           'CHEMISTRY,REACTION_SANDBOX,DITHIONITE_EXP_KAT')
      case('EXP_H')
        call InputReadDouble(input,option,this%exp_h)
        call InputErrorMsg(input,option,'EXP_H', &
                           'CHEMISTRY,REACTION_SANDBOX,DITHIONITE_EXP_KAT')
      case('EXP_S2O4')
        call InputReadDouble(input,option,this%exp_s2o4)
        call InputErrorMsg(input,option,'EXP_S2O4', &
                           'CHEMISTRY,REACTION_SANDBOX,DITHIONITE_EXP_KAT')
      case('EPS')
        call InputReadDouble(input,option,this%eps)
        call InputErrorMsg(input,option,'EPS', &
                           'CHEMISTRY,REACTION_SANDBOX,DITHIONITE_EXP_KAT')
! 8. Inform the user if the keyword is not recognized
      case default
        call InputKeywordUnrecognized(word, &
                     'CHEMISTRY,REACTION_SANDBOX,DITHIONITE_EXP_KAT',option)
    end select
  enddo

end subroutine Dithionite_exp_katRead

! ************************************************************************** !

subroutine Dithionite_exp_katSetup(this,reaction,option)
  !
  ! Sets up the dithionite_exp_kat reaction either with parameters either
  ! read from the input deck or hardwired.
  !
  ! Author: Sachin Pandey
  ! Date: 04/24/17
  !

  use Reaction_Aux_module, only : reaction_type, GetPrimarySpeciesIDFromName
  use Reaction_Mineral_Aux_module, only : GetMineralIDFromName
  use Option_module

  implicit none

  class(reaction_sandbox_dithionite_exp_kat_type) :: this
  type(reaction_type) :: reaction
  type(option_type) :: option

! 9. Add code to initialize
  this%name_spec_s2o4 = 'S2O4--'
  this%name_spec_so3 = 'SO3--'
  this%name_spec_hs  = 'HS-'
  this%name_spec_so4  = 'SO4--'
  this%name_spec_h = 'H+'

  this%id_spec_s2o4 = &
    GetPrimarySpeciesIDFromName(this%name_spec_s2o4,reaction,option)
  this%id_spec_so3 = &
    GetPrimarySpeciesIDFromName(this%name_spec_so3,reaction,option)
  this%id_spec_hs = &
    GetPrimarySpeciesIDFromName(this%name_spec_hs,reaction,option)
  this%id_spec_so4 = &
    GetPrimarySpeciesIDFromName(this%name_spec_so4,reaction,option)
  this%id_spec_h = &
    GetPrimarySpeciesIDFromName(this%name_spec_h,reaction,option)

end subroutine Dithionite_exp_katSetup

! ************************************************************************** !

subroutine Dithionite_exp_katReact(this,Residual,Jacobian,compute_derivative, &
                         rt_auxvar,global_auxvar,material_auxvar,reaction, &
                         option)
  !
  ! Evaluates reaction storing residual and/or Jacobian
  !
  ! Author: Sachin Pandey
  ! Date: 04/24/17
  !

  use Option_module
  use Reaction_Aux_module
  use Material_Aux_class

  implicit none

  class(reaction_sandbox_dithionite_exp_kat_type) :: this
  type(option_type) :: option
  type(reaction_type) :: reaction
  PetscBool :: compute_derivative
  ! the following arrays must be declared after reaction
  PetscReal :: Residual(reaction%ncomp)
  PetscReal :: Jacobian(reaction%ncomp,reaction%ncomp)
  type(reactive_transport_auxvar_type) :: rt_auxvar
  type(global_auxvar_type) :: global_auxvar
  class(material_auxvar_type) :: material_auxvar

  PetscInt, parameter :: iphase = 1
  PetscReal :: L_water, rate

  ! Unit of the residual must be in moles/second

  L_water = material_auxvar%porosity*global_auxvar%sat(iphase)* &
            material_auxvar%volume*1.d3 ! L_water from m^3_water


  ! xH^+ + 3S2O4^-2 + 3H2O -> SO3^-2 + 2HS^- + 3SO4^-2 + (4+x)H^+ 
  rate  = this%rate_constant*rt_auxvar%pri_molal(this%id_spec_s2o4)**this%exp_s2o4*rt_auxvar%pri_molal(this%id_spec_h)**this%exp_h

  if (rate < this%eps) then
    rate = 0.d0
  endif

  ! Residuals
  Residual(this%id_spec_s2o4) = Residual(this%id_spec_s2o4) - (-3.0*rate) * L_water
  Residual(this%id_spec_so3) = Residual(this%id_spec_so3) - (1.0*rate) * L_water
  Residual(this%id_spec_hs) = Residual(this%id_spec_hs) - (2.0*rate) * L_water
  Residual(this%id_spec_so4) = Residual(this%id_spec_so4) - (3.0*rate) * L_water
  Residual(this%id_spec_h) = Residual(this%id_spec_h) - (4.0*rate) * L_water

  if (compute_derivative) then

! 11. If using an analytical Jacobian, add code for Jacobian evaluation

     option%io_buffer = 'NUMERICAL_JACOBIAN_RXN must always be used ' // &
                        'due to assumptions in Dithionite_exp_kat'
     call printErrMsg(option)

  endif

end subroutine Dithionite_exp_katReact

! ************************************************************************** !

subroutine Dithionite_exp_katKineticState(this,rt_auxvar,global_auxvar, &
                                  material_auxvar,reaction,option)
  !
  ! For update mineral volume fractions
  !
  ! Author: Sachin Pandey
  ! Date: 04/24/17
  !

  use Option_module
  use Reaction_Aux_module
  use Material_Aux_class

  implicit none

  class(reaction_sandbox_dithionite_exp_kat_type) :: this
  type(option_type) :: option
  type(reaction_type) :: reaction
  ! the following arrays must be declared after reaction
  type(reactive_transport_auxvar_type) :: rt_auxvar
  type(global_auxvar_type) :: global_auxvar
  class(material_auxvar_type) :: material_auxvar

  PetscInt, parameter :: iphase = 1

end subroutine Dithionite_exp_katKineticState

! ************************************************************************** !

subroutine Dithionite_exp_katDestroy(this)
  !
  ! Destroys allocatable or pointer objects created in this
  ! module
  !
  ! Author: Sachin Pandey
  ! Date: 04/24/17
  !

  implicit none

  class(reaction_sandbox_dithionite_exp_kat_type) :: this

! 12. Add code to deallocate contents of the dithionite_exp_kat object

end subroutine Dithionite_exp_katDestroy

end module Reaction_Sandbox_Dithionite_exp_kat_class
