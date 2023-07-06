#include "jopenfst.h"

namespace fst::script {

// StateIteratorClass

extern "C" {
  StateIteratorClass *StateIteratorCreate(const FstClass *fst);
  void StateIteratorDelete(StateIteratorClass *siter);
  bool StateIteratorDone(StateIteratorClass *siter);
  int StateIteratorValue(StateIteratorClass *siter);
  void StateIteratorNext(StateIteratorClass *siter);
};

StateIteratorClass *StateIteratorCreate(const FstClass *fst) {
   return new StateIteratorClass(*fst);
}

void StateIteratorDelete(StateIteratorClass *siter) { delete siter; }

bool StateIteratorDone(StateIteratorClass *siter) { return siter->Done(); }

int StateIteratorValue(StateIteratorClass *siter) { return siter->Value(); }

void StateIteratorNext(StateIteratorClass *siter) { siter->Next(); }

// ArcIteratorClass

extern "C" {
  ArcIteratorClass *ArcIteratorCreate(const FstClass *fst, int state);
  void ArcIteratorDelete(ArcIteratorClass *aiter);
  bool ArcIteratorDone(ArcIteratorClass *aiter);
  void ArcIteratorValue(ArcIteratorClass *aiter, int *ilabel, int *olabel,
  		        double *weight, int *nextstate);
  void ArcIteratorNext(ArcIteratorClass *aiter);
  int ArcIteratorPosition(ArcIteratorClass *aiter);
  void ArcIteratorReset(ArcIteratorClass *aiter);
  void ArcIteratorSeek(ArcIteratorClass *aiter, int a);
};

ArcIteratorClass *ArcIteratorCreate(const FstClass *fst, int state) {
   return new ArcIteratorClass(*fst, state);
}

void ArcIteratorDelete(ArcIteratorClass *aiter) { delete aiter; }

bool ArcIteratorDone(ArcIteratorClass *aiter) { return aiter->Done(); }

void ArcIteratorValue(ArcIteratorClass *aiter, int *ilabel, int *olabel,
   		      double *weight, int *nextstate) { 
  const ArcClass &arc = aiter->Value();
  *ilabel = arc.ilabel;
  *olabel = arc.olabel;
  *weight = GetWeight(arc.weight);
  *nextstate = arc.nextstate;
}

void ArcIteratorNext(ArcIteratorClass *aiter) { aiter->Next(); }

int ArcIteratorPosition(ArcIteratorClass *aiter) {
  return aiter->Position();
}

void ArcIteratorReset(ArcIteratorClass *aiter) {
  return aiter->Reset();
}

void ArcIteratorSeek(ArcIteratorClass *aiter, int a) {
  return aiter->Seek(a);
}

// MutableArcIteratorClass

extern "C" {
  MutableArcIteratorClass *MutableArcIteratorCreate(
		  MutableFstClass *fst, int state);
  void MutableArcIteratorDelete(MutableArcIteratorClass *aiter);
  bool MutableArcIteratorDone(MutableArcIteratorClass *aiter);
  void MutableArcIteratorValue(MutableArcIteratorClass *aiter, 
			int *ilabel, int *olabel, 
			double *weight, int *nextstate);
  void MutableArcIteratorNext(MutableArcIteratorClass *aiter);
  int MutableArcIteratorPosition(MutableArcIteratorClass *aiter);
  void MutableArcIteratorReset(MutableArcIteratorClass *aiter);
  void MutableArcIteratorSeek(MutableArcIteratorClass *aiter, int a);
  void MutableArcIteratorSetValue(MutableArcIteratorClass *aiter, 
				  int ilabel, int olabel, 
				  double weight, int nextstate);
};

MutableArcIteratorClass *MutableArcIteratorCreate(MutableFstClass *fst, 
						  int state) {
   return new MutableArcIteratorClass(fst, state);
}

void MutableArcIteratorDelete(MutableArcIteratorClass *aiter) { delete aiter; }

bool MutableArcIteratorDone(MutableArcIteratorClass *aiter) { 
  return aiter->Done();
}

void MutableArcIteratorValue(MutableArcIteratorClass *aiter, 
			     int *ilabel, int *olabel,
			     double *weight, int *nextstate) { 
  const ArcClass &arc = aiter->Value();
  *ilabel = arc.ilabel;
  *olabel = arc.olabel;
  *weight = GetWeight(arc.weight);
  *nextstate = arc.nextstate;
}

void MutableArcIteratorNext(MutableArcIteratorClass *aiter) { aiter->Next(); }

int MutableArcIteratorPosition(MutableArcIteratorClass *aiter) {
  return aiter->Position();
}

void MutableArcIteratorReset(MutableArcIteratorClass *aiter) {
  return aiter->Reset();
}

void MutableArcIteratorSeek(MutableArcIteratorClass *aiter, int a) {
  return aiter->Seek(a);
}

void MutableArcIteratorSetValue(MutableArcIteratorClass *aiter, 
				int ilabel, int olabel, 
				double weight, int nextstate) {
  const std::string &weight_type = aiter->Value().weight.Type();
  const WeightClass &weight_class = GetWeightClass(weight, weight_type);
  ArcClass arc(ilabel, olabel, weight_class, nextstate);
  aiter->SetValue(arc);
}

}  // namespace fst::script
