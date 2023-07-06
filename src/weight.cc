#include "jopenfst.h"

namespace fst::script {

// Weight representation depends on the semiring.
double GetWeight(const WeightClass &weight) {
  if (weight.Type() == "tropical") {
    return weight.GetWeight<fst::TropicalWeight>()->Value();
  } else if (weight.Type() == "log") {
    return weight.GetWeight<fst::LogWeight>()->Value();
  } else if (weight.Type() == "log64") {
    return weight.GetWeight<fst::Log64Weight>()->Value();
  } else {
    FSTERROR() << "weight type not supported in julia";
    return 0.0;
  }
}

// Weight representation depends on the semiring.
WeightClass GetWeightClass(const double weight, 
                           const std::string &weight_type) {
  if (weight_type == "tropical") {
    return WeightClass(fst::TropicalWeight(weight));
  } else if (weight_type == "log") {
    return WeightClass(fst::LogWeight(weight));
  } else if (weight_type == "log64") {
    return WeightClass(fst::Log64Weight(weight));
  } else {
    FSTERROR() << "weight type not supported in julia";
    return WeightClass(fst::TropicalWeight::One());
  }
}

}  // namespace fst::script
