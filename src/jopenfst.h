#include <fst/script/fstscript.h>
#include <string>

namespace fst::script {

double GetWeight(const WeightClass &weight);

WeightClass GetWeightClass(const double weight,
			   const std::string &weight_type);

}  // namespace fst::script
