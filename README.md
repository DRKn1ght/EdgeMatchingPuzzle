# Edge Matching Puzzle Solver em Prolog

Este projeto é escrito em Prolog e tem como objetivo resolver um jogo de edge matching puzzle. O código utiliza duas abordagens para resolver o puzzle: retrocesso e permutação. Além disso, um comparativo é feito entre essas abordagens utilizando uma heurística específica, que consiste em reordenar o estado inicial baseado no número de vizinhos possíveis de cada bloco, de menor para o maior.

## Edge Matching Puzzle

Edge Matching Puzzle é um tipo de quebra-cabeça onde várias peças, cada uma com bordas que possuem elementos complementares, precisam ser montadas de forma que as bordas correspondam perfeitamente entre si. O objetivo do jogo é combinar todas as peças corretamente, garantindo que todas as bordas se encaixem adequadamente.

## Funcionamento

O projeto utiliza a linguagem de programação Prolog para modelar o problema do Edge Matching Puzzle e implementar duas abordagens para resolvê-lo:

1. Retrocesso: Utiliza a estratégia de retrocesso para tentar todas as combinações possíveis de encaixe entre as peças até encontrar a solução correta.

2. Permutação: Utiliza a técnica de permutação para gerar todas as possíveis disposições das peças e verificar qual delas satisfaz as restrições do jogo.

Além disso, o projeto utiliza uma heurística que reordena o estado inicial do puzzle com base no número de vizinhos possíveis de cada bloco, do menor para o maior. Essa heurística visa otimizar a busca, tornando a solução mais eficiente.

## Resultados
A tabela abaixo mostra o tempo de execução em segundos para as diferentes abordagens do projeto, com e sem a aplicação da heurística de reordenação inicial dos blocos. Os valores são baseados em testes realizados em puzzles de tamanhos médio e grande.

|        | Permutação sem reordenar os blocos | Permutação ordenando os blocos | Retrocesso sem reordenar os blocos | Retrocesso ordenando os blocos |
|--------|-----------------------------------|---------------------------------|-----------------------------------|-------------------------------|
| Médio  | 2.341 sec                         | 0.356 sec                       | 17.845 sec                        | 2.367 sec                     |
| Grande | 105.456 sec                       | 40.980 sec                      | 263.911 sec                       | 241.478 sec                   |
| Grande2| 59.579 sec                        | 15.916 sec                      | 258.245 sec                       | 102.930 sec                   |
| Grande3| 62.700 sec                        | 25.444 sec                      | 267.432 sec                       | 157.842 sec                   |
