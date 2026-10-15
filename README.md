# Operações Aritméticas Simbólicas em Haskell

Projeto acadêmico desenvolvido a partir de desafios propostos pelo professor João Paulo, com foco em **operações aritméticas simbólicas usando Haskell**.

A ideia é construir, de forma gradual, uma implementação das quatro operações aritméticas básicas — soma, subtração, multiplicação e divisão — trabalhando com representações simbólicas dos dígitos, em vez de depender diretamente das operações numéricas nativas da linguagem.

> **Status atual:** somente a **soma simbólica** está implementada. Subtração e multiplicação fazem parte dos próximos passos do projeto.

## Objetivos

- Implementar as operações aritméticas básicas em Haskell de maneira simbólica.
- Representar os números como sequências de caracteres (`String`) formadas por dígitos decimais.
- Explorar recursão, casamento de padrões (*pattern matching*) e funções puras.
- Entender como uma operação aritmética pode ser construída a partir de regras explícitas para cada dígito.
- Evoluir a implementação atual de soma para as demais operações.

## Funcionalidade implementada

### Soma simbólica

O arquivo `SomaSimbolicaFormal/somaSimbolica.hs` implementa a soma de dois números representados como texto. A função não converte as entradas para `Int`, `Integer` ou outros tipos numéricos: ela percorre os dígitos e consulta uma tabela simbólica que informa o dígito resultante e o transporte (*vai-um*).

As principais funções são:

| Função | Responsabilidade |
| --- | --- |
| `sd` | Consulta a tabela simbólica a partir de dois dígitos e do estado de transporte. Retorna o dígito resultante e o novo transporte. |
| `sa` | Processa recursivamente os dígitos das duas entradas, incluindo o transporte. |
| `s` | Interface para somar duas strings; inverte as entradas para começar pelas unidades e inverte o resultado ao final. |
| `sl` | Soma uma lista de strings usando `s`. Para uma lista vazia, retorna `"0"`. |

Exemplo conceitual: `"78" + "56"` resulta em `"134"`. O cálculo é feito dígito a dígito, propagando o transporte entre as posições.

## Tecnologias e conceitos

- **Haskell** — linguagem funcional utilizada no projeto.
- **Strings e caracteres** — representação textual dos números e dos dígitos.
- **Pattern matching** — seleção de regras a partir dos símbolos recebidos.
- **Recursão** — processamento das posições dos números.
- **Funções puras** — separação entre cálculo e entrada/saída.
- **Transporte (*vai-um*)** — estado usado durante a soma decimal.

O diretório `SomaSimbolicaFormal/AbordagemAvançada/` contém um protótipo separado que explora tipos algébricos, uma máquina de Mealy e uma implementação própria de uma mônada de estado. Ele é material de estudo complementar à implementação principal.

## Requisitos

- [GHC](https://www.haskell.org/ghc/) (Glasgow Haskell Compiler)
- [GHCi](https://www.haskell.org/ghc/) para testar as funções interativamente

A implementação principal utiliza apenas recursos básicos de Haskell e não exige bibliotecas externas.

## Como executar

Na raiz do repositório, abra um terminal e inicie o GHCi carregando o módulo principal:

```bash
ghci SomaSimbolicaFormal/somaSimbolica.hs
```

No prompt do GHCi, experimente:

```haskell
s "78" "56"
-- "134"

s "999" "1"
-- "1000"

sl ["10", "20", "3"]
-- "33"
```

Para sair do GHCi:

```haskell
:q
```

## Estrutura do repositório

```text
tasksJP/
├── README.md
└── SomaSimbolicaFormal/
    ├── somaSimbolica.hs              # Implementação principal da soma
    ├── AbordagemAvançada/
    │   ├── Prototipo.hs               # Protótipo com conceitos funcionais avançados
    │   └── docTecnica.pdf
    ├── docs/                          # Documentação e materiais explicativos
    └── fontes/                        # Referências de estudo
```

## Próximas etapas

- [x] Implementar soma simbólica decimal.
- [ ] Implementar subtração simbólica.
- [ ] Implementar multiplicação simbólica.
- [ ] Adicionar testes para casos comuns e casos-limite.
- [ ] Definir e documentar o comportamento para entradas inválidas, sinais e zeros à esquerda.

## Limitações atuais

- A implementação principal cobre apenas a soma.
- As entradas são strings de dígitos decimais; a validação de entradas inválidas ainda precisa ser aprimorada.
- Não há, por enquanto, suporte documentado a números negativos.

## Materiais de apoio

Os diretórios `SomaSimbolicaFormal/docs/` e `SomaSimbolicaFormal/fontes/` reúnem explicações, apresentações e referências utilizadas no desenvolvimento e estudo do projeto.

## Contexto acadêmico

Projeto relacionado a desafios não triviais propostos pelo professor João Paulo.
