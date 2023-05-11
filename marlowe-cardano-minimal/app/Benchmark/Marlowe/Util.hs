
{-# LANGUAGE ImportQualifiedPost #-}


module Benchmark.Marlowe.Util
where


import Codec.Serialise (deserialise)
import PlutusLedgerApi.V2 (Address (Address), BuiltinData, Credential, Datum (Datum), DatumHash,
                           LedgerBytes (getLedgerBytes),
                           OutputDatum (NoOutputDatum, OutputDatumHash), Redeemer (Redeemer),
                           ScriptHash, ScriptPurpose, TxId, TxInInfo (TxInInfo), TxOut (TxOut),
                           TxOutRef (TxOutRef), Value, adaSymbol, adaToken, dataToBuiltinData,
                           fromBuiltin, singleton)

import Data.ByteString.Lazy qualified as LBS
import PlutusTx.AssocMap qualified as AM


lovelace
  :: Integer
  -> Value
lovelace = singleton adaSymbol adaToken


makeInput
  :: TxId
  -> Integer
  -> Credential
  -> Value
  -> Maybe DatumHash
  -> Maybe ScriptHash
  -> TxInInfo
makeInput txId txIx credential value datum script =
  TxInInfo
    (TxOutRef txId txIx)
    (makeOutput credential value datum script)


makeOutput
  :: Credential
  -> Value
  -> Maybe DatumHash
  -> Maybe ScriptHash
  -> TxOut
makeOutput credential value =
  TxOut (Address credential Nothing) value
    . maybe NoOutputDatum OutputDatumHash


makeRedeemerMap
  :: ScriptPurpose
  -> LedgerBytes
  -> AM.Map ScriptPurpose Redeemer
makeRedeemerMap = (. (Redeemer . makeBuiltinData)) . AM.singleton


makeDatumMap
  :: DatumHash
  -> LedgerBytes
  -> AM.Map DatumHash Datum
makeDatumMap = (. (Datum . makeBuiltinData)) . AM.singleton


makeBuiltinData
  :: LedgerBytes
  -> BuiltinData
makeBuiltinData =
  dataToBuiltinData
    . deserialise
    . LBS.fromStrict
    . fromBuiltin
    . getLedgerBytes
