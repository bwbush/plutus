
{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}


module Benchmark.Marlowe.RolePayout (
  benchmarks
, serialisedValidator
) where


import Benchmark.Marlowe.Types (Benchmark, makeBenchmark)
import Benchmark.Marlowe.Util
    ( lovelace,
      makeBuiltinData,
      makeDatumMap,
      makeInput,
      makeOutput,
      makeRedeemerMap )
import Language.Marlowe.Scripts (rolePayoutValidatorBytes)
import PlutusLedgerApi.V2
    ( ScriptContext(ScriptContext, scriptContextTxInfo,
                    scriptContextPurpose),
      ExBudget(ExBudget),
      Credential(PubKeyCredential, ScriptCredential),
      ScriptPurpose(Spending),
      TxOutRef(TxOutRef),
      singleton,
      SerialisedScript,
      Extended(PosInf, NegInf),
      Interval(Interval),
      LowerBound(LowerBound),
      UpperBound(UpperBound),
      TxInfo(TxInfo, txInfoInputs, txInfoId, txInfoData, txInfoRedeemers,
             txInfoSignatories, txInfoValidRange, txInfoWdrl, txInfoDCert,
             txInfoMint, txInfoFee, txInfoOutputs, txInfoReferenceInputs) )

import PlutusTx.AssocMap qualified as AM


serialisedValidator :: SerialisedScript
serialisedValidator = rolePayoutValidatorBytes


benchmarks :: [Benchmark]
benchmarks = pure soleBenchmark


soleBenchmark :: Benchmark
soleBenchmark =
  let
    txInfoInputs =
      [
        makeInput
          "6ca85e35c485181d54b4092a49ed9fec93a3f21b603c68cbca741ec27de318cf" 0
          (PubKeyCredential "5411f58036fcd19b79cc51539233698dd9b86c2e53d132675b152ce8")
          (lovelace 1008173101)
          Nothing
          Nothing
      , makeInput
          "6ca85e35c485181d54b4092a49ed9fec93a3f21b603c68cbca741ec27de318cf" 1
          (PubKeyCredential "5411f58036fcd19b79cc51539233698dd9b86c2e53d132675b152ce8")
          (
             singleton "d768a767450e9ffa2d68ae61e8476fb6267884e0477d7fd19703f9d8" "Seller" 1
               <> lovelace 1034400
          )
          Nothing
          Nothing
      , makeInput
          "ef6a9ef1b84bef3dad5e12d9bf128765595be4a92da45bda2599dc7fae7e2397" 1
          (ScriptCredential "e165610232235bbbbeff5b998b233daae42979dec92a6722d9cda989")
          (lovelace 75000000)
          (Just "95de9e2c3bface3de5739c0bd5197f0864315c1819c52783afb9b2ce075215f5")
          Nothing
      ]
    txInfoReferenceInputs =
      [
        makeInput
          "9a8a6f387a3330b4141e1cb019380b9ac5c72151c0abc52aa4266245d3c555cd" 1
          (PubKeyCredential "f685ca45a4c8c07dd592ba1609690b56fdb0b81cef9440345de947f1")
          (lovelace 12899830)
          Nothing
          (Just "e165610232235bbbbeff5b998b233daae42979dec92a6722d9cda989")
      ]
    txInfoOutputs =
      [
        makeOutput
          (PubKeyCredential "5411f58036fcd19b79cc51539233698dd9b86c2e53d132675b152ce8")
          (lovelace 1082841547)
          Nothing
          Nothing
      , makeOutput
          (PubKeyCredential "5411f58036fcd19b79cc51539233698dd9b86c2e53d132675b152ce8")
          (
            singleton "d768a767450e9ffa2d68ae61e8476fb6267884e0477d7fd19703f9d8" "Seller" 1
              <> lovelace 1034400
          )
          Nothing
          Nothing
      ]
    txInfoFee = lovelace 331554
    txInfoMint = mempty
    txInfoDCert = mempty
    txInfoWdrl = AM.empty
    txInfoValidRange = Interval (LowerBound NegInf False) (UpperBound PosInf False)
    txInfoSignatories = ["5411f58036fcd19b79cc51539233698dd9b86c2e53d132675b152ce8"]
    txInfoRedeemers = makeRedeemerMap scriptContextPurpose "d87980"
    txInfoData =
      makeDatumMap
        "95de9e2c3bface3de5739c0bd5197f0864315c1819c52783afb9b2ce075215f5"
        "d8799f581cd768a767450e9ffa2d68ae61e8476fb6267884e0477d7fd19703f9d84653656c6c6572ff"
    txInfoId = "4e16f03a5533f22adbc5097a07077f3b708b1bf74b42e6b2938dd2d4156207f0"
    scriptContextTxInfo = TxInfo{..}
    scriptContextPurpose =
      Spending $ TxOutRef "ef6a9ef1b84bef3dad5e12d9bf128765595be4a92da45bda2599dc7fae7e2397" 1
  in
    makeBenchmark
      (
        makeBuiltinData
          "d8799f581cd768a767450e9ffa2d68ae61e8476fb6267884e0477d7fd19703f9d84653656c6c6572ff"
      )
      (makeBuiltinData "d87980")
      ScriptContext{..}
      (Just $ ExBudget 477988519 1726844)