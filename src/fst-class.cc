#include "jopenfst.h"

namespace fst::script {

extern "C" {
  void FstDelete(FstClass *fst);
  FstClass *FstRead(const char *file);
  bool FstWrite(const FstClass *fst, const char *file);

  int FstStart(const FstClass *fst);
  double FstFinal(const FstClass *fst, int state);
  int FstNumArcs(const FstClass *fst, int s);
  int FstNumInputEpsilons(const FstClass *fst, int s);
  int FstNumOutputEpsilons(const FstClass *fst, int s);

  const char *FstWeightType(const FstClass *fst);
  const char *FstArcType(const FstClass *fst);
  const char *FstType(const FstClass *fst);
}

// FstClass

void FstDelete(FstClass *fst) {
  delete fst;
}

FstClass *FstRead(const char *file) {
  return FstClass::Read(file);
}

bool FstWrite(const FstClass *fst, const char *file) {
  return fst->Write(file);
}

int FstStart(const FstClass *fst) {
  return fst->Start();
}

double FstFinal(const FstClass *fst, int state) {
  const WeightClass weight_class = fst->Final(state);
  return GetWeight(weight_class);
}

int FstNumArcs(const FstClass *fst, int state) {
  return fst->NumArcs(state);
}

int FstNumInputEpsilons(const FstClass *fst, int state) {
  return fst->NumInputEpsilons(state);
}

int FstNumOutputEpsilons(const FstClass *fst, int state) {
  return fst->NumOutputEpsilons(state);
}

const char *FstWeightType(const FstClass *fst) { 
  return fst->WeightType().c_str(); 
}

const char *FstArcType(const FstClass *fst) { 
  return fst->ArcType().c_str(); 
}

const char *FstType(const FstClass *fst) { 
  return fst->FstType().c_str(); 
}

// MutableFstClass

extern "C" {
  bool FstSetStart(MutableFstClass *fst, int s);
  bool FstSetFinal(MutableFstClass *fst, int s, double weight);
  bool FstAddArc(MutableFstClass *fst, int s, int ilabel, int olabel, 
		 double weight, int nextstate);
  int FstAddState(MutableFstClass *fst);
  bool FstDeleteArcs(MutableFstClass *fst, int s);
  void FstDeleteStates(MutableFstClass *fst);
  int FstNumStates(MutableFstClass *fst);
  bool FstReserveArcs(MutableFstClass *fst, int s, int n);
  void FstReserveStates(MutableFstClass *fst, int n);
};

bool FstSetStart(MutableFstClass *fst, int s) {
  return fst->SetStart(s);
}

bool FstSetFinal(MutableFstClass *fst, int s, double weight) {
  std::string weight_type = fst->WeightType();
  WeightClass weight_class = GetWeightClass(weight, weight_type); 
  return fst->SetFinal(s, weight_class);
}

bool FstAddArc(MutableFstClass *fst, int s, int ilabel, int olabel, 
    	       double weight, int nextstate) {
  std::string weight_type = fst->WeightType();
  WeightClass weight_class = GetWeightClass(weight, weight_type); 
  ArcClass arc(ilabel, olabel, weight_class, nextstate);
  return fst->AddArc(s, arc);
}

int FstAddState(MutableFstClass *fst) { return fst->AddState(); }

void FstAddStates(MutableFstClass *fst, int n) { fst->AddStates(n); }

bool FstDeleteArcs(MutableFstClass *fst, int s) {
  return fst->DeleteArcs(s);
}

void FstDeleteStates(MutableFstClass *fst) {
  fst->DeleteStates();
}

int FstNumStates(MutableFstClass *fst) {
  return fst->NumStates();
}

bool FstReserveArcs(MutableFstClass *fst, int s, int n) {
  return fst->ReserveArcs(s, n);
}

void FstReserveStates(MutableFstClass *fst, int n) {
  return fst->ReserveStates(n);
}

// VectorFstClass

extern "C" {
  VectorFstClass *VectorFstCreate(const char *arctype);
};

VectorFstClass *VectorFstCreate(const char *arctype) {
   return new VectorFstClass(arctype);
}

}  // namespace fst::script

