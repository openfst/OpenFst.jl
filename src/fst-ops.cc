#include "jopenfst.h"
#include <vector>

namespace fst::script {

extern "C" {
  FstClass *FstCompose(FstClass *fst1, FstClass *fst2);
  bool FstEqual(FstClass *fst1, FstClass *fst2, float delta);
  FstClass *FstIntersect(FstClass *fst1, FstClass *fst2);
  FstClass *FstReverse(FstClass *fst);
  double *FstShortestDistance(FstClass *fst, int *length, bool reverse,
			      double delta);
}

FstClass *FstCompose(FstClass *ifst1, FstClass *ifst2) {
  VectorFstClass *ofst = new VectorFstClass(ifst1->ArcType());
  Compose(*ifst1, *ifst2, ofst);
  return ofst;
}

bool FstEqual(FstClass *fst1, FstClass *fst2, float delta) {
  return Equal(*fst1, *fst2, delta);
}

FstClass *FstIntersect(FstClass *ifst1, FstClass *ifst2) {
  VectorFstClass *ofst = new VectorFstClass(ifst1->ArcType());
  Intersect(*ifst1, *ifst2, ofst);
  return ofst;
}

FstClass *FstReverse(FstClass *ifst) {
  VectorFstClass *ofst = new VectorFstClass(ifst->ArcType());
  Reverse(*ifst, ofst);
  return ofst;
}

double *FstShortestDistance(FstClass *fst, int *length, bool reverse, 
			    double delta) {
  std::vector<WeightClass> wdistance;
  ShortestDistance(*fst, &wdistance, reverse, delta);
  double *distance = (double *) malloc(wdistance.size() * sizeof(double));
  *length = wdistance.size();
  for (int i = 0; i < wdistance.size(); ++i)
    distance[i] = GetWeight(wdistance[i]);
  return distance;
}

}  // namespace fst::script


