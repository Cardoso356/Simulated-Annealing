# Otimização por Simulated Annealing (MATLAB)

Este projeto apresenta uma implementação em MATLAB do algoritmo **Simulated Annealing** (Recozimento Simulado), uma meta-heurística poderosa utilizada para a exploração de espaços de busca complexos e identificação de ótimos globais.

## 🧠 Sobre o Algoritmo
O Simulated Annealing simula o processo físico de recozimento de materiais para encontrar o estado de energia mínima. A grande vantagem desta técnica é a sua capacidade de aceitar, de forma probabilística, soluções piores no início do processo. Isso permite que o algoritmo escape de **ótimos locais**, aumentando as chances de encontrar a melhor solução possível (o ótimo global) para problemas de otimização.

## ⚙️ Parâmetros de Configuração
A eficácia da busca pode ser ajustada através dos seguintes hiperparâmetros definidos no código:

* **Temperatura Inicial:** Define a probabilidade inicial de aceitar soluções desfavoráveis.
* **Taxa de Resfriamento:** Controla a velocidade de redução da temperatura.
* **Critério de Parada:** Define quando a busca termina (seja por temperatura mínima atingida ou número total de iterações).
* **Geração de Vizinhos:** A lógica utilizada para explorar pequenas variações na solução atual.

## 📊 Visualização
Ao ser executado, o algoritmo produz gráficos de convergência que permitem analisar o comportamento da função objetivo em relação ao decaimento da temperatura, facilitando o ajuste fino dos parâmetros para diferentes tipos de problemas.

*Desenvolvido em ambiente MATLAB.*
