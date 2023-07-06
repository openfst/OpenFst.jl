abstract type Weight end
abstract type TropicalWeight <: Weight end
abstract type LogWeight <: Weight end
abstract type Log64Weight <: Weight end

# keyed on arc name
WeightType = Dict([("standard", TropicalWeight), ("log", LogWeight),
  	           ("log64", Log64Weight)])

ArcType = Dict([(TropicalWeight, "standard"), (LogWeight, "log"),
              (Log64Weight, "log64")])



