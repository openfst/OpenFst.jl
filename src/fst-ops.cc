#include "jopenfst.h"
#include <vector>

namespace fst::script {

extern "C" {
  void FstClosure(MutableFstClass *fst1);
  void FstConnect(MutableFstClass *fst1);
  FstClass *FstCompose(const FstClass *fst1, const FstClass *fst2);
  void FstConcat(MutableFstClass *fst1, const FstClass *fst2);
  bool FstEqual(const FstClass *fst1, const FstClass *fst2, float delta);
  bool FstEquivalent(const FstClass *fst1, const FstClass *fst2, float delta);
  FstClass *FstDeterminize(const FstClass *fst, double delta);
  FstClass *FstDifference(const FstClass *fst1, const FstClass *fst2);
  FstClass *FstDisambiguate(const FstClass *fst, double delta);
  FstClass *FstIntersect(const FstClass *fst1, const FstClass *fst2);
  void FstInvert(MutableFstClass *fst);
  bool FstIsomorphic(const FstClass *fst1, const FstClass *fst2, float delta);
  void FstMinimize(MutableFstClass *fst);
  void FstPrune(MutableFstClass *fst, double delta);
  FstClass *FstRandGen(const FstClass *fst);
  FstClass *FstReverse(const FstClass *fst);
  void FstRmEpsilon(MutableFstClass *fst);
  double *FstShortestDistance(const FstClass *fst, int *length, bool reverse,
			      double delta);
  FstClass *FstSynchronize(const FstClass *fst);
  void FstTopSort(MutableFstClass *fst);
  void FstUnion(MutableFstClass *fst1, const FstClass *fst2);
}

FstClass *FstCompose(const FstClass *ifst1, const FstClass *ifst2) {
  VectorFstClass *ofst = new VectorFstClass(ifst1->ArcType());
  Compose(*ifst1, *ifst2, ofst);
  return ofst;
}

void FstClosure(MutableFstClass *fst) {
  Closure(fst, CLOSURE_STAR);
}

void FstConcat(MutableFstClass *fst1, const FstClass *fst2) {
  Concat(fst1, *fst2);
}

void FstConnext(MutableFstClass *fst) {
  Connect(fst);
}

FstClass *FstDeterminize(const FstClass *ifst, double delta) {
  VectorFstClass *ofst = new VectorFstClass(ifst->ArcType());
  WeightClass zero(WeightClass::Zero(ifst->WeightType()));
  DeterminizeOptions opts(delta, zero);
  Determinize(*ifst, ofst, opts);
  return ofst;
}

FstClass *FstDifference(const FstClass *ifst1, const FstClass *ifst2) {
  VectorFstClass *ofst = new VectorFstClass(ifst1->ArcType());
  Difference(*ifst1, *ifst2, ofst);
  return ofst;
}

FstClass *FstDisambiguate(const FstClass *ifst, double delta) {
  VectorFstClass *ofst = new VectorFstClass(ifst->ArcType());
  WeightClass zero(WeightClass::Zero(ifst->WeightType()));
  DisambiguateOptions opts(delta, zero);
  Disambiguate(*ifst, ofst, opts);
  return ofst;
}

bool FstEqual(const FstClass *fst1, const FstClass *fst2, float delta) {
  return Equal(*fst1, *fst2, delta);
}

bool FstEquivalent(const FstClass *fst1, const FstClass *fst2, float delta) {
  return Equivalent(*fst1, *fst2, delta);
}

FstClass *FstIntersect(const FstClass *ifst1, const FstClass *ifst2) {
  VectorFstClass *ofst = new VectorFstClass(ifst1->ArcType());
  Intersect(*ifst1, *ifst2, ofst);
  return ofst;
}

void FstInvert(MutableFstClass *fst) {
  Invert(fst);
}

void FstMinimize(MutableFstClass *fst) {
  Minimize(fst);
}

void FstPrune(MutableFstClass *fst, double threshold) {
  WeightClass weight_threshold = GetWeightClass(threshold,
						fst->WeightType());
  Prune(fst, weight_threshold);
}

FstClass *FstRandGen(const FstClass *ifst) {
  VectorFstClass *ofst = new VectorFstClass(ifst->ArcType());
  RandGen(*ifst, ofst);
  return ofst;
}

FstClass *FstReverse(const FstClass *ifst) {
  VectorFstClass *ofst = new VectorFstClass(ifst->ArcType());
  Reverse(*ifst, ofst);
  return ofst;
}

void FstRmEpsilon(MutableFstClass *fst) {
  WeightClass zero(WeightClass::Zero(fst->WeightType()));
  RmEpsilonOptions opts(AUTO_QUEUE, true, zero);
  RmEpsilon(fst, opts);
}

double *FstShortestDistance(const FstClass *fst, int *length, bool reverse, 
			    double delta) {
  std::vector<WeightClass> wdistance;
  ShortestDistance(*fst, &wdistance, reverse, delta);
  double *distance = (double *) malloc(wdistance.size() * sizeof(double));
  *length = wdistance.size();
  for (int i = 0; i < wdistance.size(); ++i)
    distance[i] = GetWeight(wdistance[i]);
  return distance;
}

FstClass *FstSynchronize(const FstClass *ifst) {
  VectorFstClass *ofst = new VectorFstClass(ifst->ArcType());
  Synchronize(*ifst, ofst);
  return ofst;
}

void FstTopSort(MutableFstClass *fst) {
  TopSort(fst);
}

void FstUnion(MutableFstClass *fst1, const FstClass *fst2) {
  Union(fst1, *fst2);
}

}  // namespace fst::script
