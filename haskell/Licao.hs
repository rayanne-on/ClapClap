module Licao where

import Exercicio
import Data.List (intercalate)
import Data.List.Split (splitOn)
import System.Directory (renameFile, removeFile)

data Licao = Licao {
    exercicios :: [Exercicio],
    status :: String,
    instrucao  :: String
} deriving (Show, Read)

getDadosLicoes :: IO [(String, String)]
getDadosLicoes = do
    conteudo <- readFile "../dados/tabela_licao.txt"
    let linhas = tail $ map (splitOn ";") (lines conteudo)
    return $ map (\[id, status] -> (id, status)) linhas

getStatusLicoes :: String -> [(String, String)] -> String
getStatusLicoes idLicao [] = ""
getStatusLicoes idLicao dados =
    let (id, status) = head dados
    in if id == idLicao
        then status
        else getStatusLicoes idLicao (tail dados)

contaLicoesConcluidas :: [Licao] -> Int
contaLicoesConcluidas [] = 0
contaLicoesConcluidas (licao:licoes) =
    if (status licao) == "concluido"
    then 1 + contaLicoesConcluidas licoes
    else contaLicoesConcluidas licoes

corrigeExercicio :: String -> [(Char, String)] -> [(Char, String)]
corrigeExercicio entrada [] = []
corrigeExercicio "" ((gabarito, cor):gabaritos) = [(gabarito, "red")] ++ corrigeExercicio "" gabaritos
corrigeExercicio (en:entrada) ((gabarito, cor):gabaritos) =
    if en == gabarito
    then [(gabarito, "green")] ++ corrigeExercicio entrada gabaritos
    else [(gabarito, "red")] ++ corrigeExercicio entrada gabaritos

atualizaLinha :: String -> String -> String
atualizaLinha idLicao linha =
    let [id, status] = splitOn ";" linha
    in if id == idLicao
       then intercalate ";" [id, "concluido"]
       else linha

setStatusLicao :: String -> IO ()
setStatusLicao idLicao = do
    let filePath = "../dados/tabela_licao.txt"
        tempFilePath = filePath ++ ".tmp"

    conteudo <- readFile filePath
    let linhas = lines conteudo
        linhasProcessadas = map (\linha -> atualizaLinha idLicao linha) linhas

    writeFile tempFilePath (unlines linhasProcessadas)

    renameFile tempFilePath filePath