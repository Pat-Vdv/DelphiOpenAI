﻿unit ChatGPT.API.Edits;

interface

uses
  ChatGPT.API.Params;

type
  TEditParams = class(TJSONParam)
    /// <summary>
    /// ID of the model to use. You can use the List models API to see all of your available models,
    /// or see our Model overview for descriptions of them.
    /// </summary>
    function Model(const Value: string): TEditParams;
    /// <summary>
    /// The input text to use as a starting point for the edit.
    /// </summary>
    function Input(const Value: string): TEditParams; overload;
    /// <summary>
    /// The instruction that tells the model how to edit the prompt.
    /// </summary>
    function Instruction(const Value: string): TEditParams; overload;
    /// <summary>
    /// What sampling temperature to use. Higher values means the model will take more risks.
    /// Try 0.9 for more creative applications, and 0 (argmax sampling) for ones with a well-defined answer.
    /// We generally recommend altering this or top_p but not both.
    /// </summary>
    function Temperature(const Value: Single = 1): TEditParams;
    /// <summary>
    /// An alternative to sampling with temperature, called nucleus sampling,
    /// where the model considers the results of the tokens with top_p probability mass.
    /// So 0.1 means only the tokens comprising the top 10% probability mass are considered.
    /// We generally recommend altering this or temperature but not both.
    /// </summary>
    function TopP(const Value: Single = 1): TEditParams;
    /// <summary>
    /// How many edits to generate for the input and instruction.
    /// </summary>
    function N(const Value: Integer = 1): TEditParams;
    constructor Create; override;
  end;

  TGPTEditUsage = class
  private
    FCompletion_tokens: Int64;
    FPrompt_tokens: Int64;
    FTotal_tokens: Int64;
  public
    property CompletionTokens: Int64 read FCompletion_tokens write FCompletion_tokens;
    property PromptTokens: Int64 read FPrompt_tokens write FPrompt_tokens;
    property TotalTokens: Int64 read FTotal_tokens write FTotal_tokens;
  end;

  TGPTEditChoices = class
  private
    FIndex: Int64;
    FText: string;
  public
    property Index: Int64 read FIndex write FIndex;
    property Text: string read FText write FText;
  end;

  TGPTEdits = class
  private
    FChoices: TArray<TGPTEditChoices>;
    FCreated: Int64;
    FObject: string;
    FUsage: TGPTEditUsage;
  public
    property &Object: string read FObject write FObject;
    property Choices: TArray<TGPTEditChoices> read FChoices write FChoices;
    property Created: Int64 read FCreated write FCreated;
    property Usage: TGPTEditUsage read FUsage write FUsage;
    destructor Destroy; override;
  end;

implementation

{ TGPTEdits }

destructor TGPTEdits.Destroy;
begin
  if Assigned(FUsage) then
    FUsage.Free;
  for var Item in FChoices do
    Item.Free;
  inherited;
end;

{ TEditParams }

constructor TEditParams.Create;
begin
  inherited;
  Model('text-davinci-edit-001');
  Temperature(0);
end;

function TEditParams.Model(const Value: string): TEditParams;
begin
  Result := TEditParams(Add('model', Value));
end;

function TEditParams.N(const Value: Integer): TEditParams;
begin
  Result := TEditParams(Add('n', Value));
end;

function TEditParams.Input(const Value: string): TEditParams;
begin
  Result := TEditParams(Add('input', Value));
end;

function TEditParams.Instruction(const Value: string): TEditParams;
begin
  Result := TEditParams(Add('instruction', Value));
end;

function TEditParams.Temperature(const Value: Single): TEditParams;
begin
  Result := TEditParams(Add('temperature', Value));
end;

function TEditParams.TopP(const Value: Single): TEditParams;
begin
  Result := TEditParams(Add('top_p', Value));
end;

end.

