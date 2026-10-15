{-# LANGUAGE InstanceSigs #-}

module SomaSimbolicaFormal where

-- SEÇÃO 1: TIPOS ALGÉBRICOS DE DADOS (ADTs) & PATTERN MATCHING EXAUSTIVO

-- | Dígitos decimais mapeados como um Tipo Soma finito.
-- Garante Type Safety: impossível representar caracteres ou valores inválidos.
data Digito = D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | D8 | D9
  deriving (Show, Eq)

-- | O Estado da FSM de adição: representa a presença ou ausência de transporte ("vai-um").
data VaiUm = SemVaiUm | ComVaiUm
  deriving (Show, Eq)

-- | Função de conversão do ADT para Char (apenas na fronteira I/O de exibição/saída).
digitoParaChar :: Digito -> Char
digitoParaChar D0 = '0'
digitoParaChar D1 = '1'
digitoParaChar D2 = '2'
digitoParaChar D3 = '3'
digitoParaChar D4 = '4'
digitoParaChar D5 = '5'
digitoParaChar D6 = '6'
digitoParaChar D7 = '7'
digitoParaChar D8 = '8'
digitoParaChar D9 = '9'

-- | Função de conversão de Char para ADT (apenas no parsing da entrada).
charParaDigito :: Char -> Digito
charParaDigito '0' = D0
charParaDigito '1' = D1
charParaDigito '2' = D2
charParaDigito '3' = D3
charParaDigito '4' = D4
charParaDigito '5' = D5
charParaDigito '6' = D6
charParaDigito '7' = D7
charParaDigito '8' = D8
charParaDigito '9' = D9
charParaDigito _   = error "Caractere não é um dígito válido"

-- | Tabela de Transição de Estado e Saída da Máquina de Mealy:
-- transicaoMealy :: (Digito, Digito) -> VaiUm -> (Digito, VaiUm)
-- Demonstra Completude Funcional via Pattern Matching Exaustivo.
transicaoMealy :: (Digito, Digito) -> VaiUm -> (Digito, VaiUm)
transicaoMealy (d1, d2) v = somarComCarry d1 d2 v
  where
    -- Soma primária de dois dígitos
    somar :: Digito -> Digito -> (Digito, VaiUm)
    somar D0 x  = (x, SemVaiUm)
    somar x D0  = (x, SemVaiUm)
    
    somar D1 D1 = (D2, SemVaiUm)
    somar D1 D2 = (D3, SemVaiUm)
    somar D1 D3 = (D4, SemVaiUm)
    somar D1 D4 = (D5, SemVaiUm)
    somar D1 D5 = (D6, SemVaiUm)
    somar D1 D6 = (D7, SemVaiUm)
    somar D1 D7 = (D8, SemVaiUm)
    somar D1 D8 = (D9, SemVaiUm)
    somar D1 D9 = (D0, ComVaiUm)
    
    somar D2 D2 = (D4, SemVaiUm)
    somar D2 D3 = (D5, SemVaiUm)
    somar D2 D4 = (D6, SemVaiUm)
    somar D2 D5 = (D7, SemVaiUm)
    somar D2 D6 = (D8, SemVaiUm)
    somar D2 D7 = (D9, SemVaiUm)
    somar D2 D8 = (D0, ComVaiUm)
    somar D2 D9 = (D1, ComVaiUm)

    somar D3 D3 = (D6, SemVaiUm)
    somar D3 D4 = (D7, SemVaiUm)
    somar D3 D5 = (D8, SemVaiUm)
    somar D3 D6 = (D9, SemVaiUm)
    somar D3 D7 = (D0, ComVaiUm)
    somar D3 D8 = (D1, ComVaiUm)
    somar D3 D9 = (D2, ComVaiUm)

    somar D4 D4 = (D8, SemVaiUm)
    somar D4 D5 = (D9, SemVaiUm)
    somar D4 D6 = (D0, ComVaiUm)
    somar D4 D7 = (D1, ComVaiUm)
    somar D4 D8 = (D2, ComVaiUm)
    somar D4 D9 = (D3, ComVaiUm)

    somar D5 D5 = (D0, ComVaiUm)
    somar D5 D6 = (D1, ComVaiUm)
    somar D5 D7 = (D2, ComVaiUm)
    somar D5 D8 = (D3, ComVaiUm)
    somar D5 D9 = (D4, ComVaiUm)

    somar D6 D6 = (D2, ComVaiUm)
    somar D6 D7 = (D3, ComVaiUm)
    somar D6 D8 = (D4, ComVaiUm)
    somar D6 D9 = (D5, ComVaiUm)

    somar D7 D7 = (D4, ComVaiUm)
    somar D7 D8 = (D5, ComVaiUm)
    somar D7 D9 = (D6, ComVaiUm)

    somar D8 D8 = (D6, ComVaiUm)
    somar D8 D9 = (D7, ComVaiUm)

    somar D9 D9 = (D8, ComVaiUm)
    
    -- Comutatividade simétrica
    somar x y   = somar y x

    -- Adiciona o estado inicial de entrada ("vai-um") à soma
    somarComCarry :: Digito -> Digito -> VaiUm -> (Digito, VaiUm)
    somarComCarry x y SemVaiUm = somar x y
    somarComCarry x y ComVaiUm =
      let (r1, v1) = somar x y
          (r2, v2) = somar r1 D1
      in (r2, combinarVaiUm v1 v2)

    combinarVaiUm :: VaiUm -> VaiUm -> VaiUm
    combinarVaiUm ComVaiUm _ = ComVaiUm
    combinarVaiUm _ ComVaiUm = ComVaiUm
    combinarVaiUm _ _        = SemVaiUm


-- SEÇÃO 2: ENCAPSULAMENTO COM A STATE MONAD & CATEGORIA KLEISLI

-- | Monad de Estado customizada para encapsular a evolução pura do autômato.
newtype ST s a = ST { runST :: s -> (a, s) }

instance Functor (ST s) where
  fmap :: (a -> b) -> ST s a -> ST s b
  fmap g st = ST $ \s ->
    let (x, s') = runST st s
    in (g x, s')

instance Applicative (ST s) where
  pure :: a -> ST s a
  pure x = ST $ \s -> (x, s)
  
  (<*>) :: ST s (a -> b) -> ST s a -> ST s b
  stf <*> stx = ST $ \s ->
    let (f, s')  = runST stf s
        (x, s'') = runST stx s'
    in (f x, s'')

instance Monad (ST s) where
  (>>=) :: ST s a -> (a -> ST s b) -> ST s b
  st >>= f = ST $ \s ->
    let (x, s') = runST st s
    in runST (f x) s'

-- | Transição monádica: consome um par de dígitos e transforma o estado (VaiUm)
-- produzindo o dígito resultado no contexto da State Monad.
pasoMealyMonad :: (Digito, Digito) -> ST VaiUm Digito
pasoMealyMonad par = ST $ \estadoAtual ->
  let (digitoSaida, novoEstado) = transicaoMealy par estadoAtual
  in (digitoSaida, novoEstado)

-- | Operador de Composição da Categoria Kleisli (>=>)[cite: 2, 4].
-- Demonstra a composição de dois passos monádicos de autômato[cite: 2, 4].
kleisliComp :: (a -> ST s b) -> (b -> ST s c) -> (a -> ST s c)
kleisliComp f g = \x -> f x >>= g


-- SEÇÃO 3: EXECUÇÃO, ALINHAMENTO DE DIGITOS E SOMA SIMBÓLICA

-- | Alinha duas listas de dígitos da direita para a esquerda adicionando D0.
alinharDigitos :: [Digito] -> [Digito] -> ([(Digito, Digito)], [Digito])
alinharDigitos xs ys = (zip xsPadded ysPadded, [])
  where
    maxLen = max (length xs) (length ys)
    pad l  = l ++ replicate (maxLen - length l) D0
    xsPadded = pad xs
    ysPadded = pad ys

-- | Processa a sequência de pares através do estado acumulado (vai-um).
-- Utiliza do-notation e a estrutura monádica sequenciada[cite: 1, 2].
processarSoma :: [(Digito, Digito)] -> ST VaiUm [Digito]
processarSoma [] = do
  v <- ST $ \s -> (s, s)
  case v of
    ComVaiUm -> return [D1]
    SemVaiUm -> return []
processarSoma (p:ps) = do
  d <- pasoMealyMonad p
  ds <- processarSoma ps
  return (d : ds)

-- | Soma de duas Strings utilizando internamente o Autômato de Mealy Monádico.
somaDois :: String -> String -> String
somaDois s1 s2 =
  let d1 = map charParaDigito (reverse s1)
      d2 = map charParaDigito (reverse s2)
      (pares, _) = alinharDigitos d1 d2
      (resDigitos, _) = runST (processarSoma pares) SemVaiUm
      resString = map digitoParaChar (reverse resDigitos)
  in if null resString then "0" else resString

-- | Soma de uma lista de N números via redução com foldl1
somaLista :: [String] -> String
somaLista [] = "0"
somaLista xs = foldl1 somaDois xs