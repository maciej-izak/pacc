unit PACCIntermediateRepresentationCode;
{$i PACC.inc}

interface

uses SysUtils,Classes,Math,PUCU,PACCTypes,PACCGlobals,PACCPointerHashMap,PACCAbstractSyntaxTree;

type PPACCIntermediateRepresentationCodeOpcode=^TPACCIntermediateRepresentationCodeOpcode;
     TPACCIntermediateRepresentationCodeOpcode=
      (
       pircoNONE,

       pircoASM,

       pircoADD,
       pircoSUB,
       pircoDIV,
       pircoREM,
       pircoUDIV,
       pircoUREM,
       pircoMUL,
       pircoAND,
       pircoOR,
       pircoXOR,
       pircoSAR,
       pircoSHR,
       pircoSHL,
       pircoCI32ule,
       pircoCI32ult,
       pircoCI32sle,
       pircoCI32slt,
       pircoCI32uge,
       pircoCI32ugt,
       pircoCI32sge,
       pircoCI32sgt,
       pircoCI32eq,
       pircoCI32ne,
       pircoCI64ule,
       pircoCI64ult,
       pircoCI64sle,
       pircoCI64slt,
       pircoCI64uge,
       pircoCI64ugt,
       pircoCI64sge,
       pircoCI64sgt,
       pircoCI64eq,
       pircoCI64ne,
       pircoCF32le,
       pircoCF32lt,
       pircoCF32ge,
       pircoCF32gt,
       pircoCF32eq,
       pircoCF32ne,
       pircoCF64le,
       pircoCF64lt,
       pircoCF64ge,
       pircoCF64gt,
       pircoCF64eq,
       pircoCF64ne,

       pircoSTOREI8,
       pircoSTOREI16,
       pircoSTOREI32,
       pircoSTOREI64,
       pircoSTOREF32,
       pircoSTOREF64,

       pircoLOADUI8,
       pircoLOADSI8,
       pircoLOADUI16,
       pircoLOADSI16,
       pircoLOADUI32,
       pircoLOADSI32,
       pircoLOADUI64,
       pircoLOADSI64,
       pircoLOAD,

       pircoZEROEXTENDI8,
       pircoSIGNEXTENDI8,
       pircoZEROEXTENDI16,
       pircoSIGNEXTENDI16,
       pircoZEROEXTENDI32,
       pircoSIGNEXTENDI32,
       pircoZEROEXTENDI64,
       pircoSIGNEXTENDI64,

       pircoCONVF32TOF64,
       pircoCONVF64TOF32,
       pircoCONVF32TOI32,
       pircoCONVF32TOI64,
       pircoCONVF64TOI32,
       pircoCONVF64TOI64,
       pircoCONVI32TOF32,
       pircoCONVI32TOF64,
       pircoCONVI64TOF32,
       pircoCONVI64TOF64,

       pircoALLOC,
       pircoALLOC1,
       pircoALLOC2,
       pircoALLOC4,
       pircoALLOC8,
       pircoALLOC16,

       pircoCOPY,

       pircoPAR,
       pircoPARC,
       pircoARG,
       pircoARGC,
       pircoCALL,

       pircoNOP,
       pircoADDR,
       pircoSWAP,
       pircoSIGN,
       pircoSALLOC,
       pircoXIDIV,
       pircoXDIV,

       picroCOUNT
      );

     PPACCIntermediateRepresentationCodeReferenceType=^TPACCIntermediateRepresentationCodeReferenceType;
     TPACCIntermediateRepresentationCodeReferenceType=
      (
       pircrtNONE,
       pircrtTEMPORARY,
       pircrtCONSTANT,
       pircrtSLOT,
       pircrtTYPE,
       pircrtCALL,
       pircrtMEMORY,
       pircrtVARIABLE,
       pircrtLABEL
      );

     PPACCIntermediateRepresentationCodeReference=^TPACCIntermediateRepresentationCodeReference;
     TPACCIntermediateRepresentationCodeReference=record
      case Type_:TPACCIntermediateRepresentationCodeReferenceType of
       pircrtNONE,
       pircrtTEMPORARY,
       pircrtCONSTANT,
       pircrtSLOT,
       pircrtTYPE,
       pircrtCALL,
       pircrtMEMORY:(
        Value:TPACCUInt32;
       );
       pircrtVARIABLE:(
        Variable:TPACCAbstractSyntaxTreeNodeLocalGlobalVariable;
       );
       pircrtLABEL:(
        Label_:TPACCAbstractSyntaxTreeNodeLabel;
       );
     end;

     PPACCIntermediateRepresentationCodeClass=^TPACCIntermediateRepresentationCodeClass;
     TPACCIntermediateRepresentationCodeClass=
      (
       pirccNONE,
       pirccI8,
       pirccI16,
       pirccI32,
       pirccI64,
       pirccF32,
       pirccF64
      );

     PPACCIntermediateRepresentationCodeInstruction=^TPACCIntermediateRepresentationCodeInstruction;
     TPACCIntermediateRepresentationCodeInstruction={$ifdef HAS_ADVANCED_RECORDS}record{$else}object{$endif}
      public
       Opcode:TPACCIntermediateRepresentationCodeOpcode;
       Class_:TPACCIntermediateRepresentationCodeClass;
       To_:TPACCIntermediateRepresentationCodeReference;
       Arguments:array[0..1] of TPACCIntermediateRepresentationCodeReference;
       function Create(const AOpcode:TPACCIntermediateRepresentationCodeOpcode):TPACCIntermediateRepresentationCodeInstruction; overload;
       function Create(const AOpcode:TPACCIntermediateRepresentationCodeOpcode;const AClass_:TPACCIntermediateRepresentationCodeClass):TPACCIntermediateRepresentationCodeInstruction; overload;
       function Create(const AOpcode:TPACCIntermediateRepresentationCodeOpcode;const AClass_:TPACCIntermediateRepresentationCodeClass;const ATo_:TPACCIntermediateRepresentationCodeReference):TPACCIntermediateRepresentationCodeInstruction; overload;
       function Create(const AOpcode:TPACCIntermediateRepresentationCodeOpcode;const AClass_:TPACCIntermediateRepresentationCodeClass;const ATo_,AArgument:TPACCIntermediateRepresentationCodeReference):TPACCIntermediateRepresentationCodeInstruction; overload;
       function Create(const AOpcode:TPACCIntermediateRepresentationCodeOpcode;const AClass_:TPACCIntermediateRepresentationCodeClass;const ATo_,AArgument,AOtherArgument:TPACCIntermediateRepresentationCodeReference):TPACCIntermediateRepresentationCodeInstruction; overload;
     end;

     TPACCIntermediateRepresentationCodeInstructions=array of TPACCIntermediateRepresentationCodeInstruction;

     PPACCIntermediateRepresentationCodeJumpType=^TPACCIntermediateRepresentationCodeJumpType;
     TPACCIntermediateRepresentationCodeJumpType=
      (
       pircjtNONE,
       pircjtRET0,
       pircjtRETI8,
       pircjtRETI16,
       pircjtRETI32,
       pircjtRETI64,
       pircjtRETF32,
       pircjtRETF64,
       pircjtRETC,
       pircjtJMP,
       pircjtJNZ,
       pircjtJZ
      );

     PPACCIntermediateRepresentationCodeJump=^TPACCIntermediateRepresentationCodeJump;
     TPACCIntermediateRepresentationCodeJump=record
      Type_:TPACCIntermediateRepresentationCodeJumpType;
      Argument:TPACCIntermediateRepresentationCodeReference;
     end;

     PPACCIntermediateRepresentationCodeBlock=^TPACCIntermediateRepresentationCodeBlock;
     TPACCIntermediateRepresentationCodeBlock=class;

     TPACCIntermediateRepresentationCodeBlocks=array of TPACCIntermediateRepresentationCodeBlock;

     PPACCIntermediateRepresentationCodePhi=^TPACCIntermediateRepresentationCodePhi;
     TPACCIntermediateRepresentationCodePhi=record
      To_:TPACCIntermediateRepresentationCodeReference;
      Arguments:array of TPACCIntermediateRepresentationCodeReference;
      Blocks:array of TPACCIntermediateRepresentationCodeBlock;
      CountArguments:TPACCInt32;
      Class_:TPACCIntermediateRepresentationCodeClass;
      Link:PPACCIntermediateRepresentationCodePhi;
     end;

     TPACCIntermediateRepresentationCodeBitSet={$ifdef HAVE_ADVANCED_RECORDS}record{$else}object{$endif}
      private
       fBitmap:array of TPACCUInt32;
       fBitmapSize:TPACCInt32;
       function GetBit(const AIndex:TPACCInt32):boolean;
       procedure SetBit(const AIndex:TPACCInt32;const ABit:boolean);
      public
       procedure Clear;
       property BitmapSize:TPACCInt32 read fBitmapSize;
       property Bits[const AIndex:TPACCInt32]:boolean read GetBit write SetBit; default;
     end;

     TPACCIntermediateRepresentationCodeBlock=class
      private
       fInstance:TObject;
      public

       Index:TPACCInt32;

       Label_:TPACCAbstractSyntaxTreeNodeLabel;

       Phi:PPACCIntermediateRepresentationCodePhi;

       Instructions:TPACCIntermediateRepresentationCodeInstructions;
       CountInstructions:TPACCINt32;

       Jump:TPACCIntermediateRepresentationCodeJump;

       Successors:array[0..1] of TPACCIntermediateRepresentationCodeBlock;

       Link:TPACCIntermediateRepresentationCodeBlock;

       ID:TPACCInt32;
       Visit:TPACCInt32;

       InverseDominance:TPACCIntermediateRepresentationCodeBlock;
       Dominance:TPACCIntermediateRepresentationCodeBlock;
       DominanceLink:TPACCIntermediateRepresentationCodeBlock;

       Fronts:TPACCIntermediateRepresentationCodeBlocks;
       CountFronts:TPACCInt32;

       Predecessors:TPACCIntermediateRepresentationCodeBlocks;
       CountPredecessors:TPACCInt32;

       In_:TPACCIntermediateRepresentationCodeBitSet;
       Out_:TPACCIntermediateRepresentationCodeBitSet;
       Gen_:TPACCIntermediateRepresentationCodeBitSet;

       CountLive:array[0..1] of TPACCInt32;
       Loop:TPACCInt32;

       constructor Create(const AInstance:TObject); reintroduce;
       destructor Destroy; override;

       function AddInstruction(const AInstruction:TPACCIntermediateRepresentationCodeInstruction):TPACCInt32;

      published
       property Instance:TObject read fInstance;
     end;

     TPACCIntermediateRepresentationCodeBlockList=class(TList)
      private
       function GetItem(const AIndex:TPACCInt):TPACCIntermediateRepresentationCodeBlock;
       procedure SetItem(const AIndex:TPACCInt;const AItem:TPACCIntermediateRepresentationCodeBlock);
      public
       constructor Create;
       destructor Destroy; override;
       property Items[const AIndex:TPACCInt]:TPACCIntermediateRepresentationCodeBlock read GetItem write SetItem; default;
     end;

     TPACCIntermediateRepresentationCode=class
      private

       fInstance:TObject;

      public

       Blocks:TPACCIntermediateRepresentationCodeBlockList;

       BlockLabelHashMap:TPACCPointerHashMap;

       StartBlock:TPACCIntermediateRepresentationCodeBlock;

       TemporaryReferenceCounter:TPACCUInt32;

       VariableTemporaryReferenceHashMap:TPACCPointerHashMap;

       constructor Create(const AInstance:TObject); reintroduce;
       destructor Destroy; override;

      published
       property Instance:TObject read fInstance;
     end;

procedure GenerateIntermediateRepresentationCode(const AInstance:TObject;const ARootAbstractSyntaxTreeNode:TPACCAbstractSyntaxTreeNode);

implementation

uses PACCInstance;

function TPACCIntermediateRepresentationCodeInstruction.Create(const AOpcode:TPACCIntermediateRepresentationCodeOpcode):TPACCIntermediateRepresentationCodeInstruction;
begin
 Opcode:=AOpcode;
 Class_:=pirccNONE;
 To_.Type_:=pircrtNONE;
 Arguments[0].Type_:=pircrtNONE;
 Arguments[1].Type_:=pircrtNONE;
 result:=self;
end;

function TPACCIntermediateRepresentationCodeInstruction.Create(const AOpcode:TPACCIntermediateRepresentationCodeOpcode;const AClass_:TPACCIntermediateRepresentationCodeClass):TPACCIntermediateRepresentationCodeInstruction;
begin
 Opcode:=AOpcode;
 Class_:=AClass_;
 To_.Type_:=pircrtNONE;
 Arguments[0].Type_:=pircrtNONE;
 Arguments[1].Type_:=pircrtNONE;
 result:=self;
end;

function TPACCIntermediateRepresentationCodeInstruction.Create(const AOpcode:TPACCIntermediateRepresentationCodeOpcode;const AClass_:TPACCIntermediateRepresentationCodeClass;const ATo_:TPACCIntermediateRepresentationCodeReference):TPACCIntermediateRepresentationCodeInstruction;
begin
 Opcode:=AOpcode;
 Class_:=AClass_;
 To_:=ATo_;
 Arguments[0].Type_:=pircrtNONE;
 Arguments[1].Type_:=pircrtNONE;
 result:=self;
end;

function TPACCIntermediateRepresentationCodeInstruction.Create(const AOpcode:TPACCIntermediateRepresentationCodeOpcode;const AClass_:TPACCIntermediateRepresentationCodeClass;const ATo_,AArgument:TPACCIntermediateRepresentationCodeReference):TPACCIntermediateRepresentationCodeInstruction;
begin
 Opcode:=AOpcode;
 Class_:=AClass_;
 To_:=ATo_;
 Arguments[0]:=AArgument;
 Arguments[1].Type_:=pircrtNONE;
 result:=self;
end;

function TPACCIntermediateRepresentationCodeInstruction.Create(const AOpcode:TPACCIntermediateRepresentationCodeOpcode;const AClass_:TPACCIntermediateRepresentationCodeClass;const ATo_,AArgument,AOtherArgument:TPACCIntermediateRepresentationCodeReference):TPACCIntermediateRepresentationCodeInstruction;
begin
 Opcode:=AOpcode;
 Class_:=AClass_;
 To_:=ATo_;
 Arguments[0]:=AArgument;
 Arguments[1]:=AOtherArgument;
 result:=self;
end;

function TPACCIntermediateRepresentationCodeBitSet.GetBit(const AIndex:TPACCInt32):boolean;
begin
 result:=((AIndex>=0) and (AIndex<(fBitmapSize shl 3))) and
         ((fBitmap[AIndex shr 3] and (TPACCUInt32(1) shl (AIndex and 31)))<>0);
end;

procedure TPACCIntermediateRepresentationCodeBitSet.SetBit(const AIndex:TPACCInt32;const ABit:boolean);
var OldSize,Index:TPACCInt32;
begin
 if AIndex>=0 then begin
  if (fBitmapSize shl 3)<=AIndex then begin
   fBitmapSize:=(AIndex+31) shr 3;
   OldSize:=length(fBitmap);
   if OldSize<fBitmapSize then begin
    SetLength(fBitmap,fBitmapSize*2);
    FillChar(fBitmap[OldSize],(length(fBitmap)-OldSize)*SizeOf(TPACCUInt32),#0);
   end;
  end;
  if ABit then begin
   fBitmap[AIndex shr 3]:=fBitmap[AIndex shr 3] or (TPACCUInt32(1) shl (AIndex and 31));
  end else begin
   fBitmap[AIndex shr 3]:=fBitmap[AIndex shr 3] and not (TPACCUInt32(1) shl (AIndex and 31));
  end;
 end;
end;

procedure TPACCIntermediateRepresentationCodeBitSet.Clear;
begin
 fBitmap:=nil;
 fBitmapSize:=0;
end;

constructor TPACCIntermediateRepresentationCodeBlock.Create(const AInstance:TObject);
begin
 inherited Create;

 fInstance:=AInstance;
 TPACCInstance(fInstance).AllocatedObjects.Add(self);

 Index:=0;

 Label_:=nil;

 Phi:=nil;

 Instructions:=nil;
 CountInstructions:=0;

 Jump.Type_:=pircjtNONE;

 Successors[0]:=nil;
 Successors[1]:=nil;

 Link:=nil;

 ID:=0;
 Visit:=0;

 InverseDominance:=nil;
 Dominance:=nil;
 DominanceLink:=nil;

 Fronts:=nil;
 CountFronts:=0;

 Predecessors:=nil;
 CountPredecessors:=0;

 In_.Clear;
 Out_.Clear;
 Gen_.Clear;

 CountLive[0]:=0;
 CountLive[1]:=0;
 Loop:=0;

end;

destructor TPACCIntermediateRepresentationCodeBlock.Destroy;
begin

 if assigned(Phi) then begin
  Finalize(Phi^);
  FreeMem(Phi);
  Phi:=nil;
 end;

 Instructions:=nil;

 Fronts:=nil;
 CountFronts:=0;

 Predecessors:=nil;
 CountPredecessors:=0;

 In_.Clear;
 Out_.Clear;
 Gen_.Clear;

 inherited Destroy;
end;

function TPACCIntermediateRepresentationCodeBlock.AddInstruction(const AInstruction:TPACCIntermediateRepresentationCodeInstruction):TPACCInt32;
begin
 result:=CountInstructions;
 inc(CountInstructions);
 if length(Instructions)<CountInstructions then begin
  SetLength(Instructions,CountInstructions*2);
 end;
 Instructions[result]:=AInstruction;
end;

constructor TPACCIntermediateRepresentationCodeBlockList.Create;
begin
 inherited Create;
end;

destructor TPACCIntermediateRepresentationCodeBlockList.Destroy;
begin
 inherited Destroy;
end;

function TPACCIntermediateRepresentationCodeBlockList.GetItem(const AIndex:TPACCInt):TPACCIntermediateRepresentationCodeBlock;
begin
 result:=pointer(inherited Items[AIndex]);
end;

procedure TPACCIntermediateRepresentationCodeBlockList.SetItem(const AIndex:TPACCInt;const AItem:TPACCIntermediateRepresentationCodeBlock);
begin
 inherited Items[AIndex]:=pointer(AItem);
end;

constructor TPACCIntermediateRepresentationCode.Create(const AInstance:TObject);
begin
 inherited Create;

 fInstance:=AInstance;
 TPACCInstance(fInstance).AllocatedObjects.Add(self);

 Blocks:=TPACCIntermediateRepresentationCodeBlockList.Create;

 BlockLabelHashMap:=TPACCPointerHashMap.Create;

 StartBlock:=nil;

 TemporaryReferenceCounter:=0;

 VariableTemporaryReferenceHashMap:=TPACCPointerHashMap.Create;

end;

destructor TPACCIntermediateRepresentationCode.Destroy;
begin
 Blocks.Free;
 BlockLabelHashMap.Free;
 VariableTemporaryReferenceHashMap.Free;
 inherited Destroy;
end;

function GenerateIntermediateRepresentationCodeForFunction(const AInstance:TObject;const AFunctionNode:TPACCAbstractSyntaxTreeNodeFunctionCallOrFunctionDeclaration):TPACCIntermediateRepresentationCode;
var CurrentBlock:TPACCIntermediateRepresentationCodeBlock;
    BlockLink,PhiLink:PPACCIntermediateRepresentationCodeBlock;
    CodeInstance:TPACCIntermediateRepresentationCode;
    NeedNewBlock:boolean;
 function GetVariableReference(Variable:TPACCAbstractSyntaxTreeNodeLocalGlobalVariable):TPACCIntermediateRepresentationCodeReference;
 var Entity:PPACCPointerHashMapEntity;
 begin
  case Variable.Kind of
   astnkLVAR:begin
    result.Type_:=pircrtTEMPORARY;
    Entity:=CodeInstance.VariableTemporaryReferenceHashMap.Get(Variable,false);
    if assigned(Entity) then begin
     result.Value:=TPACCPtrUInt(pointer(Entity^.Value));
    end else begin
     result.Value:=CodeInstance.TemporaryReferenceCounter;
     CodeInstance.VariableTemporaryReferenceHashMap[Variable]:=pointer(TPACCPtrUInt(CodeInstance.TemporaryReferenceCounter));
     inc(CodeInstance.TemporaryReferenceCounter);
    end;
   end;
   astnkGVAR:begin
    result.Type_:=pircrtVARIABLE;
    result.Variable:=Variable;
   end;
   else begin
    result.Type_:=pircrtNONE;
    TPACCInstance(AInstance).AddError('Internal error 2017-01-20-16-29-0000',nil,true);
   end;
  end;
 end;
 function NewHiddenLabel:TPACCAbstractSyntaxTreeNodeLabel;
 begin
  result:=TPACCAbstractSyntaxTreeNodeLabel.Create(AInstance,astnkHIDDEN_LABEL,nil,TPACCInstance(AInstance).SourceLocation,'');
 end;
 procedure CloseBlock;
 begin
  BlockLink:=@CurrentBlock.Link;
  NeedNewBlock:=true;
 end;
 function FindBlock(const Label_:TPACCAbstractSyntaxTreeNodeLabel):TPACCIntermediateRepresentationCodeBlock;
 begin
  result:=CodeInstance.BlockLabelHashMap[Label_];
  if not assigned(result) then begin
   result:=TPACCIntermediateRepresentationCodeBlock.Create(AInstance);
   result.Index:=CodeInstance.Blocks.Add(result);
   result.Label_:=Label_;
   CodeInstance.BlockLabelHashMap[Label_]:=result;
  end;
 end;
 procedure EmitLabel(const Label_:TPACCAbstractSyntaxTreeNodeLabel);
 var Block:TPACCIntermediateRepresentationCodeBlock;
 begin
  Block:=FindBlock(Label_);
  if assigned(CurrentBlock) and (CurrentBlock.Jump.Type_=pircjtNONE) then begin
   CloseBlock;
   CurrentBlock.Jump.Type_:=pircjtJMP;
   CurrentBlock.Successors[0]:=Block;
  end;
  if Block.Jump.Type_<>pircjtNONE then begin
   TPACCInstance(AInstance).AddError('Internal error 2017-01-20-14-42-0000',nil,true);
  end;
  BlockLink^:=Block;
  CurrentBlock:=Block;
  PhiLink:=@CurrentBlock.Phi;
  NeedNewBlock:=false;
 end;
 procedure EmitJump(const Label_:TPACCAbstractSyntaxTreeNodeLabel);
 var Block:TPACCIntermediateRepresentationCodeBlock;
 begin
  Block:=FindBlock(Label_);
  CurrentBlock.Jump.Type_:=pircjtJMP;
  CurrentBlock.Successors[0]:=Block;
  CloseBlock;
 end;
 procedure CreateNewBlockIfNeeded;
 begin
  if NeedNewBlock then begin
   EmitLabel(NewHiddenLabel);
  end;
 end;
 procedure ProcessNode(const Node:TPACCAbstractSyntaxTreeNode;const OutputResultReference:PPACCIntermediateRepresentationCodeReference);
 var Index:TPACCInt32;
     ResultReference:TPACCIntermediateRepresentationCodeReference;
 begin
  if assigned(Node) then begin

   ResultReference.Type_:=pircrtNONE;

   case Node.Kind of

    astnkINTEGER:begin
    end;

    astnkFLOAT:begin
    end;

    astnkSTRING:begin
    end;

    astnkLVAR:begin
    end;

    astnkGVAR:begin
    end;

    astnkTYPEDEF:begin
    end;

    astnkASSEMBLER:begin
    end;

    astnkASSEMBLER_OPERAND:begin
    end;

    astnkFUNCCALL:begin
    end;

    astnkFUNCPTR_CALL:begin
    end;

    astnkFUNCDESG:begin
    end;

    astnkFUNC:begin
    end;

    astnkEXTERN_DECL:begin
    end;

    astnkDECL:begin
    end;

    astnkINIT:begin
    end;

    astnkCONV:begin
    end;

    astnkADDR:begin
    end;

    astnkDEREF:begin
    end;

    astnkFOR:begin
    end;

    astnkDO:begin
    end;

    astnkWHILE:begin
    end;

    astnkSWITCH:begin
    end;

    astnkIF:begin
    end;

    astnkTERNARY:begin
    end;

    astnkRETURN:begin
    end;

    astnkSTATEMENTS:begin
     for Index:=0 to TPACCAbstractSyntaxTreeNodeStatements(Node).Children.Count-1 do begin
      ProcessNode(TPACCAbstractSyntaxTreeNodeStatements(Node).Children[Index],nil);
     end;
    end;

    astnkSTRUCT_REF:begin
    end;

    astnkGOTO:begin
     EmitJump(TPACCAbstractSyntaxTreeNodeLabel(TPACCAbstractSyntaxTreeNodeGOTOStatementOrLabelAddress(Node).Label_));
    end;

    astnkCOMPUTED_GOTO:begin
    end;

    astnkLABEL:begin
     EmitLabel(TPACCAbstractSyntaxTreeNodeLabel(Node));
    end;

    astnkHIDDEN_LABEL:begin
     EmitLabel(TPACCAbstractSyntaxTreeNodeLabel(Node));
    end;

    astnkBREAK:begin
     EmitJump(TPACCAbstractSyntaxTreeNodeLabel(TPACCAbstractSyntaxTreeNodeBREAKOrCONTINUEStatement(Node).Label_));
    end;

    astnkCONTINUE:begin
     EmitJump(TPACCAbstractSyntaxTreeNodeLabel(TPACCAbstractSyntaxTreeNodeBREAKOrCONTINUEStatement(Node).Label_));
    end;

    astnkOP_COMMA:begin
    end;

    astnkOP_ARROW:begin
    end;

    astnkOP_ASSIGN:begin
    end;

    astnkOP_SIZEOF:begin
    end;

    astnkOP_CAST:begin
    end;

    astnkOP_NOT:begin
    end;

    astnkOP_NEG:begin
    end;

    astnkOP_PRE_INC:begin
    end;

    astnkOP_PRE_DEC:begin
    end;

    astnkOP_POST_INC:begin
    end;

    astnkOP_POST_DEC:begin
    end;

    astnkOP_LABEL_ADDR:begin
    end;

    astnkOP_ADD:begin
    end;

    astnkOP_SUB:begin
    end;

    astnkOP_MUL:begin
    end;

    astnkOP_DIV:begin
    end;

    astnkOP_MOD:begin
    end;

    astnkOP_AND:begin
    end;

    astnkOP_OR:begin
    end;

    astnkOP_XOR:begin
    end;

    astnkOP_SHL:begin
    end;

    astnkOP_SHR:begin
    end;

    astnkOP_SAR:begin
    end;

    astnkOP_LOG_AND:begin
    end;

    astnkOP_LOG_OR:begin
    end;

    astnkOP_LOG_NOT:begin
    end;

    astnkOP_EQ:begin
    end;

    astnkOP_NE:begin
    end;

    astnkOP_GT:begin
    end;

    astnkOP_LT:begin
    end;

    astnkOP_GE:begin
    end;

    astnkOP_LE:begin
    end;

    astnkOP_A_ADD:begin
    end;

    astnkOP_A_SUB:begin
    end;

    astnkOP_A_MUL:begin
    end;

    astnkOP_A_DIV:begin
    end;

    astnkOP_A_MOD:begin
    end;

    astnkOP_A_AND:begin
    end;

    astnkOP_A_OR:begin
    end;

    astnkOP_A_XOR:begin
    end;

    astnkOP_A_SHR:begin
    end;

    astnkOP_A_SHL:begin
    end;

    astnkOP_A_SAL:begin
    end;

    astnkOP_A_SAR:begin
    end;

   end;

   if assigned(OutputResultReference) then begin
    OutputResultReference^:=ResultReference;
   end;

  end;
 end;
var Index,ParameterIndex:longint;
    LocalVariable:TPACCAbstractSyntaxTreeNodeLocaLGlobalVariable;
    Reference:TPACCIntermediateRepresentationCodeReference;
begin

 result:=TPACCIntermediateRepresentationCode.Create(AInstance);

 CodeInstance:=result;

 CurrentBlock:=nil;
 BlockLink:=@CodeInstance.StartBlock;
 PhiLink:=nil;

 NeedNewBlock:=true;

 EmitLabel(NewHiddenLabel);

 for Index:=0 to AFunctionNode.LocalVariables.Count-1 do begin

  LocalVariable:=TPACCAbstractSyntaxTreeNodeLocalGlobalVariable(AFunctionNode.LocalVariables[Index]);
  if assigned(LocalVariable) then begin

   Reference:=GetVariableReference(LocalVariable);

   ParameterIndex:=AFunctionNode.Parameters.IndexOf(LocalVariable);
   if ParameterIndex>=0 then begin

   end;

  end;

 end;

 ProcessNode(AFunctionNode.Body,nil);

 if CurrentBlock.Jump.Type_=pircjtNONE then begin
  CurrentBlock.Jump.Type_:=pircjtRET0;
 end;
end;

procedure GenerateIntermediateRepresentationCode(const AInstance:TObject;const ARootAbstractSyntaxTreeNode:TPACCAbstractSyntaxTreeNode);
var Index:TPACCInt32;
    RootAbstractSyntaxTreeNode:TPACCAbstractSyntaxTreeNodeTranslationUnit;
    Node:TPACCAbstractSyntaxTreeNode;
begin
 if assigned(ARootAbstractSyntaxTreeNode) and
    (TPACCAbstractSyntaxTreeNode(ARootAbstractSyntaxTreeNode).Kind=astnkTRANSLATIONUNIT) and
    (ARootAbstractSyntaxTreeNode is TPACCAbstractSyntaxTreeNodeTranslationUnit) then begin
  RootAbstractSyntaxTreeNode:=TPACCAbstractSyntaxTreeNodeTranslationUnit(ARootAbstractSyntaxTreeNode);
  for Index:=0 to RootAbstractSyntaxTreeNode.Children.Count-1 do begin
   Node:=RootAbstractSyntaxTreeNode.Children[Index];
   if assigned(Node) and (Node.Kind=astnkFUNC) then begin
    GenerateIntermediateRepresentationCodeForFunction(AInstance,TPACCAbstractSyntaxTreeNodeFunctionCallOrFunctionDeclaration(Node));
   end;
  end;
 end else begin
  TPACCInstance(AInstance).AddError('Internal error 2017-01-19-11-48-0000',nil,true);
 end;
end;

end.
