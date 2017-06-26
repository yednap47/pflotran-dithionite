template !
# Id: pflotran-reaction-simple.in, Wed 02 Nov 2016 09:41:54 AM MDT pandeys #
# Created by Sachin Pandey, LANL
# Description: Test simple reactions on 2D grid
#------------------------------------------------------------------------------

SIMULATION
  SIMULATION_TYPE SUBSURFACE
  PROCESS_MODELS
    SUBSURFACE_TRANSPORT transport
      GLOBAL_IMPLICIT
      NUMERICAL_JACOBIAN
    /
  /
#  RESTART 1d-allReactions-10m-checkpoint-restart.chk 0.
END

SUBSURFACE

#=========================== useful tranport parameters ==================
UNIFORM_VELOCITY !q! 0.d0 0.d0 m/d

#=========================== chemistry ========================================
CHEMISTRY
  PRIMARY_SPECIES
    A(aq)
    H+
    O2(aq)
    CrO4--
    S2O4--
    S2O3--
    SO3--
    SO4--
    Fe+++
    Cr+++
    HCO3-
    Ca++
    K+
  /
  SECONDARY_SPECIES
    OH-
    CO3--
    CO2(aq)
  /
  IMMOBILE_SPECIES
    slow_Fe++
    fast_Fe++
  /
  REACTION_SANDBOX
    S2O4_DISP
      RATE_CONSTANT !k_s2o4_disp! # /s, Istok (1999), 0.13 /hr
      EPS 1.d-50
    /
    S2O4_O2
      RATE_CONSTANT !k_s2o4_o2! # /s
      EPS 1.d-50
    /
    S2O4_FE3
      RATE_CONSTANT !k_s2o4_fe3! # /s
      SSA 175 # m^2/g
      ROCK_DENSITY 1200.d0 # m^3/m^3_bulk
      FRACTION !fraction!
      EPS 1.d-50
    /
    FE2_O2
      RATE_CONSTANT_SLOW !k_fe2_o2_slow! # /s
      RATE_CONSTANT_FAST !k_fe2_o2_fast! # /s
      ROCK_DENSITY 1200.d0 # kg/m^3_bulk
      EPS 1.d-50
    /
    FE2_CR6
      RATE_CONSTANT_SLOW !k_fe2_cr6_slow! # /s
      RATE_CONSTANT_FAST !k_fe2_cr6_fast!  # /s
      ROCK_DENSITY 1200.d0 # kg/m^3_bulk
      EPS 1.d-50
    /
  /
  MINERALS
    Fe(OH)3(s)
    Cr(OH)3(s)
    Calcite
  /
  MINERAL_KINETICS
    Fe(OH)3(s)
      RATE_CONSTANT 1.d-5 mol/m^2-sec
    /
    Cr(OH)3(s)
      RATE_CONSTANT 1.d-5 mol/m^2-sec
    /
    Calcite
      RATE_CONSTANT 1.d-5 mol/m^2-sec
    /
  /
  DATABASE /lclscratch/sach/Programs/pflotran-dithionite-git/chrome-dithionite-tests/chromium_dithionite_2017.dat
  ACTIVITY_COEFFICIENTS TIMESTEP
  LOG_FORMULATION
  OUTPUT
    ALL
    TOTAL
    PH
#    FREE_ION
#    SECONDARY_SPECIES
  /
END

#=========================== solver options ===================================
NEWTON_SOLVER TRANSPORT
#  RTOL 1.d-12
#  STOL 1.d-30
END

#=========================== discretization ===================================
GRID
  TYPE structured
  NXYZ 260 1 1
  DXYZ
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 \ 
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 \ 
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 \ 
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 \ 
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 \ 
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 \ 
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 \ 
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 \ 
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 \ 
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 \ 
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 \ 
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 \ 
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 \ 
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 \ 
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 \ 
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 \ 
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 \ 
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 \ 
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 \ 
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 \ 
    0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 \ 
    0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 \ 
    0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 \ 
    0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 \ 
    0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2 \ 
    0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2 0.2 
    0.1 
    0.1 
  /
END

#=========================== fluid properties =================================
FLUID_PROPERTY
  DIFFUSION_COEFFICIENT 1.d-9
END

#=========================== material properties ==============================
MATERIAL_PROPERTY soil1
  ID 1
  POROSITY 0.15d0
  TORTUOSITY 1.d0
  SATURATION_FUNCTION cc1
  ROCK_DENSITY 1200.d0 # kg/m^3_bulk
  PERMEABILITY
     PERM_ISO 2.36944d-11
  /
#  LONGITUDINAL_DISPERSIVITY 5.d0
END

#=========================== characteristic curves ============================
CHARACTERISTIC_CURVES cc1
  SATURATION_FUNCTION VAN_GENUCHTEN
    ALPHA  1.d-4
    M 0.5d0
    LIQUID_RESIDUAL_SATURATION 0.1d0
  /
  PERMEABILITY_FUNCTION MUALEM_VG_LIQ
    M 0.5d0
    LIQUID_RESIDUAL_SATURATION 0.1d0
  /
END

#=========================== output options ===================================
OUTPUT
#  FORMAT HDF5
  VELOCITY_AT_CENTER
  TIMES d 1.0 11.0 21.0 31.0 61.0 81.0 91.0 101.0 121.0 151.0 161.0 171.0 181.0 191.0 201.0 211.0 221.0 231.0 241.0 251.0 261.0 271.0 281.0 291.0 301.0 311.0 321.0 331.0 341.0 351.0 361.0
  PRINT_COLUMN_IDS
  MASS_BALANCE_FILE
  TIMES d 1.0 11.0 21.0 31.0 61.0 81.0 91.0 101.0 121.0 151.0 161.0 171.0 181.0 191.0 201.0 211.0 221.0 231.0 241.0 251.0 261.0 271.0 281.0 291.0 301.0 311.0 321.0 331.0 341.0 351.0 361.0
  /
END

#=========================== times ============================================
TIME
  FINAL_TIME 365.d0 d
  INITIAL_TIMESTEP_SIZE 1.d-10 d 
  MAXIMUM_TIMESTEP_SIZE 1.d-1 d at 0.0 d
  MAXIMUM_TIMESTEP_SIZE 1.d0 d at 15.0 d
END

#=========================== regions ==========================================
REGION all
  COORDINATES
    0.d0 0.d0 0.d0
    10.0 1.d-1 1.d-1
  /
END

REGION west
  FACE west
  COORDINATES
    0.d0 0.d0 0.d0
    0.d0 1.d-1 1.d-1
  /
END

REGION east
  FACE east
  COORDINATES
    10.0 0.d0 0.d0
    10.0 1.d-1 1.d-1
  /
END

#=========================== flow conditions ==================================

#=========================== transport conditions =============================
TRANSPORT_CONDITION initial
  TYPE dirichlet
  CONSTRAINT_LIST
    0.d0 initial
  /
END

TRANSPORT_CONDITION inlet
  TYPE dirichlet_zero_gradient
  CONSTRAINT_LIST
    0.0  d injectant
    15.0 d inlet
  /
END

TRANSPORT_CONDITION outlet
  TYPE dirichlet_zero_gradient
  CONSTRAINT_LIST
    0.d0 inlet
  /
END

#=========================== constraints ======================================^M
CONSTRAINT initial
  CONCENTRATIONS
    A(aq)   1.d-20 T
    H+      -0.00011723 T
    O2(aq)  2.84d-4 T
    CrO4--  1.92d-5 T # 1000 ppb
    S2O4--  1.d-20 T
    S2O3--  1.d-20 T
    SO3--   1.d-20 T
    SO4--   1.d-20 T
    Fe+++   1.d-20 T
    Cr+++   1.d-20 T
    HCO3-   0.000117229 T
    Ca++    0.000117229 T
    K+      1.00d-05
  /
  MINERALS
    Fe(OH)3(s) !ifeoh3!  1.d3 # 1% mass percent
    Cr(OH)3(s) 1.d-20 1.d3
    Calcite    0.00999858 1.d3
  /
  IMMOBILE
    slow_Fe++ 1.0d-20
    fast_Fe++ 1.0d-20
  /
END

CONSTRAINT inlet
  CONCENTRATIONS
    A(aq)   1.d-20 T
    H+      -0.00011723 T
    O2(aq)  2.84d-4 T
    CrO4--  1.92d-5 T # 1000 ppb
    S2O4--  1.d-20 T
    S2O3--  1.d-20 T
    SO3--   1.d-20 T
    SO4--   1.d-20 T
    Fe+++   1.d-20 T
    Cr+++   1.d-20 T
    HCO3-   0.000117229 T
    Ca++    0.000117229 T
    K+      1.00d-05
  /
END

CONSTRAINT injectant
  CONCENTRATIONS
    A(aq)   1.d-1 T
    H+     -0.4 T
    O2(aq)  2.84d-4 T
    CrO4--  1.d-20 T
    S2O4--  !is2o4! T
    S2O3--  1.d-20 T
    SO3--   1.d-20 T
    SO4--   1.d-20 T
    Fe+++   1.d-20 T
    Cr+++   1.d-20 T
    HCO3-   0.4 T
    Ca++    1.d-20 T
    K+      0.4 T
  /
END

#=========================== condition couplers ===============================
# initial condition
INITIAL_CONDITION
  TRANSPORT_CONDITION initial
  REGION all
END

BOUNDARY_CONDITION west
  TRANSPORT_CONDITION inlet
  REGION west 
END

BOUNDARY_CONDITION east  
  TRANSPORT_CONDITION outlet
  REGION east
END

#=========================== stratigraphy couplers ============================
STRATA
  REGION all 
  MATERIAL soil1
END

END_SUBSURFACE
