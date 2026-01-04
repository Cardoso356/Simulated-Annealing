clear all;close all;clc;

%  ALGORITMO SIMULATED ANNEALING (SA)

% gera um único indivíduo, modelado como um vetor de 3 posições [Kp, Ki, Kd]
function SolucaoInicial = GeraSolucaoInicial(limite_min, limite_max_Kp, limite_max_Ki, limite_max_Kd)
    Kp = rand()*(limite_max_Kp - limite_min)+limite_min; %para colocar o valor de kp na faixa desejada
    Ki = rand()*(limite_max_Ki - limite_min)+limite_min; %para colocar o valor de ki na faixa desejada
    Kd = rand()*(limite_max_Kd - limite_min)+limite_min; %para colocar o valor de kd na faixa desejada

    SolucaoInicial = [Kp Ki Kd]; %retorna o valor do indivíduo
end

% geração de solução vizinha com método de perturbação uniforme
function SolucaoVizinha = GeraSolucaoVizinhaPerturbacaoUniforme(SolucaoInicial, deltaKp, deltaKi, deltaKd, limite_min, limite_max_Kp, limite_max_Ki, limite_max_Kd)
    
    Kp = SolucaoInicial(1) + (rand()*2-1)*deltaKp; % (rand()*2-1) gera um valor aleatório entre -1 e +1 e *deltaKp deixa o valor dentro do intervalo de -deltaKp a +deltaKp
    if Kp > limite_max_Kp
        Kp = limite_max_Kp;
    else
        if Kp < limite_min
            Kp = limite_min;
        end
    end
    
    Ki = SolucaoInicial(2) + (rand()*2-1)*deltaKi;
    if Ki > limite_max_Ki
        Ki = limite_max_Ki;
    else
        if Ki < limite_min
            Ki = limite_min;
        end
    end

    Kd = SolucaoInicial(3) + (rand()*2-1)*deltaKd;
     if Kd > limite_max_Kd
        Kd = limite_max_Kd;
    else
        if Kd < limite_min
            Kd = limite_min;
        end
    end
    
    SolucaoVizinha = [Kp Ki Kd];

end

% geração de solução vizinha com método de perturbação gaussiana
function SolucaoVizinha = GeraSolucaoVizinhaPerturbacaoGaussiana(SolucaoInicial, limite_min, limite_max_Kp, limite_max_Ki, limite_max_Kd, sigmaKp, sigmaKi, sigmaKd)

    Kp = SolucaoInicial(1) + randn()*sigmaKp;
    if Kp > limite_max_Kp
        Kp = limite_max_Kp;
    else
        if Kp < limite_min
            Kp = limite_min;
        end
    end

    Ki = SolucaoInicial(2) + randn()*sigmaKi;
    if Ki > limite_max_Ki
        Ki = limite_max_Ki;
    else
        if Ki < limite_min
            Ki = limite_min;
        end
    end

    Kd = SolucaoInicial(3) + randn()*sigmaKd;
     if Kd > limite_max_Kd
        Kd = limite_max_Kd;
    else
        if Kd < limite_min
            Kd = limite_min;
        end
    end

    SolucaoVizinha = [Kp Ki Kd];

end

function SolucaoVizinha = GeraSolucaoVizinhaPerturbacaoTriangular(SolucaoInicial, limite_min, limite_max_Kp, limite_max_Ki, limite_max_Kd, deltaKp, deltaKi, deltaKd)
    
    Kp = SolucaoInicial(1) + (rand() + rand() - 1)*deltaKp; %fica no intervalo de [-1,+1]
    if Kp > limite_max_Kp
        Kp = limite_max_Kp;
    else
        if Kp < limite_min
            Kp = limite_min;
        end
    end

    Ki = SolucaoInicial(2) + (rand() + rand() - 1)*deltaKi;
    if Ki > limite_max_Ki
        Ki = limite_max_Ki;
    else
        if Ki < limite_min
            Ki = limite_min;
        end
    end

    Kd = SolucaoInicial(3) + (rand() + rand() - 1)*deltaKd;
    if Kd > limite_max_Kd
        Kd = limite_max_Kd;
    else
        if Kd < limite_min
            Kd = limite_min;
        end
    end

    SolucaoVizinha = [Kp Ki Kd];

end


function SolucaoVizinha = GeraSolucaoVizinhaPerturbacaoCauchy(SolucaoInicial, limite_min, limite_max_Kp, limite_max_Ki, limite_max_Kd, gammaKp, gammaKi, gammaKd)

    U1 = rand();
    U2 = rand();
    U3 = rand();
    
    Kp = SolucaoInicial(1) + gammaKp*tan(pi*(U1-0.5));
    if Kp > limite_max_Kp
            Kp = limite_max_Kp;
        else
            if Kp < limite_min
                Kp = limite_min;
            end
        end
    
    Ki = SolucaoInicial(2) + gammaKi*tan(pi*(U2-0.5));
    if Ki > limite_max_Ki
            Ki = limite_max_Ki;
        else
            if Ki < limite_min
                Ki = limite_min;
            end
        end
    
    Kd = SolucaoInicial(3) + gammaKd*tan(pi*(U3-0.5));
    if Kd > limite_max_Kd
            Kd = limite_max_Kd;
        else
            if Kd < limite_min
                Kd = limite_min;
            end
        end
    
        SolucaoVizinha = [Kp Ki Kd];
    end

% método adaptativo que utiliza os quatro métodos de geração de solução
%vizinha utilizando o critério do desempenho da solução
function [SolucaoVizinha, EstadoAtual] = GeraSolucaoVizinhaMetodoAdaptativo(SolucaoInicial, EstadoAtual, limite_min, limite_max_Kp, limite_max_Ki, limite_max_Kd, deltaKp, deltaKi, deltaKd, sigmaKp, sigmaKi, sigmaKd,gammaKp, gammaKi, gammaKd)

    % criação da lista de métodos de geração de solução vizinha
    vizinhancas = {
        @(SolucaoInicial) GeraSolucaoVizinhaPerturbacaoUniforme(SolucaoInicial, deltaKp, deltaKi, deltaKd, limite_min, limite_max_Kp, limite_max_Ki, limite_max_Kd), 
        @(SolucaoInicial) GeraSolucaoVizinhaPerturbacaoGaussiana(SolucaoInicial, limite_min, limite_max_Kp, limite_max_Ki, limite_max_Kd, sigmaKp, sigmaKi, sigmaKd), 
        @(SolucaoInicial) GeraSolucaoVizinhaPerturbacaoTriangular(SolucaoInicial, limite_min, limite_max_Kp, limite_max_Ki, limite_max_Kd, deltaKp, deltaKi, deltaKd), 
        @(SolucaoInicial) GeraSolucaoVizinhaPerturbacaoCauchy(SolucaoInicial, limite_min, limite_max_Kp, limite_max_Ki, limite_max_Kd, gammaKp, gammaKi, gammaKd)
    };

    nomesVizinhancas = {
        'Perturbação Uniforme'
        'Perturbação Gaussiana'
        'Perturbação Triangular'
        'Perturbação de Cauchy'

    };

    % aplicação do método de solução vizinha atual
    MetodoDeSolucaoVizinha_Atual = EstadoAtual.MetodoDeSolucaoVizinha_Atual;

    fprintf("**[INFO] O método de geração de solução vizinha atual é: Método de %s**\n\n", nomesVizinhancas{MetodoDeSolucaoVizinha_Atual});

    SolucaoVizinha = vizinhancas{MetodoDeSolucaoVizinha_Atual}(SolucaoInicial);

    % Realização da troca de métodos de forma adaptativa
    if EstadoAtual.IteracoesSemMelhora >= EstadoAtual.LimiteDeEstagnacao
        EstadoAtual.MetodoDeSolucaoVizinha_Atual = mod(EstadoAtual.MetodoDeSolucaoVizinha_Atual, numel(vizinhancas)) + 1;
        EstadoAtual.IteracoesSemMelhora = 0;
        fprintf("\n=====================================================================\n");
        fprintf("Trocando para o método de solução vizinha por %s (adaptativo)\n", nomesVizinhancas{EstadoAtual.MetodoDeSolucaoVizinha_Atual});
        fprintf("========================================================================\n\n\n");
    end

end

function Funcao_objetivo = Simula_Avalia(Kp,Ki,Kd)
    m = 0.105;
    R = 0.03;
    J = 3.78*10^-5;
    g = -9.81;
    L = 0.5;
    d = 0.12;
    
    s = tf('s');
    FuncaoDeTransferencia = -m*g*d/L/(m+(J/R^2))/s^2;
    controlador = pid(Kp,Ki,Kd);
    
    malhaFechada = feedback(FuncaoDeTransferencia*controlador,1);
    setpoint = 0.2;
    t = 0:0.01:60;
    
    y = step(setpoint*malhaFechada,t);
    
    IAE = 0;
        for i = 1:length(t)
            erro = setpoint - y(i);
            IAE = IAE + abs(erro);
        end
    
    Funcao_objetivo = IAE; %retorno da função
end

% função principal do Simulated Annealing
function [MelhorSolucao, MelhorDesempenho, HistoricoMelhores] = SimulatedAnnealing(Temperatura, Temperatura_min, alpha, Nk , limite_min, limite_max_Kp, limite_max_Ki, limite_max_Kd, deltaKp, deltaKi, deltaKd, sigmaKp, sigmaKi, sigmaKd, gammaKp, gammaKi, gammaKd)

    fprintf("Temperatura atual do sistema: T = %.2fºC \n\n", Temperatura);

    % geração da solução inicial/atual
    SolucaoAtual = GeraSolucaoInicial(limite_min, limite_max_Kp, limite_max_Ki, limite_max_Kd);
    fprintf("Soluçao atual: Kp = %.4f, Ki = %.4f, Kd = %.4f", SolucaoAtual)

    % calcula o desempenho da solução atual
    IAE_atual = Simula_Avalia(SolucaoAtual(1), SolucaoAtual(2), SolucaoAtual(3));
    fprintf(" - IAE = %.4f \n\n", IAE_atual)

    % inicialização da melhor solução e seu desempenho
    MelhorSolucao = SolucaoAtual;
    MelhorDesempenho = IAE_atual;

    iteracao_total = 0; % contador de iterações globais

    % Vetor para armazenar o menor IAE de cada temperatura
    HistoricoMelhores = []; %salva [Temperatura, MelhorIAE, Kp, Ki, Kd]

    % para o método adaptativo
    EstadoAtual.MetodoDeSolucaoVizinha_Atual = 1; % 1->Uniforme; 2->Gaussiana; 3->Triangular; 4->Cauchy
    EstadoAtual.IteracoesSemMelhora = 0;           % contador de iterações sem melhora
    EstadoAtual.LimiteDeEstagnacao = 2;            % limite para troca de método de solução vizinha

    % laço principal: controle da temperatura
    while Temperatura >= Temperatura_min

        % Variáveis para armazenar o melhor desta temperatura
        MelhorTemp_IAE = inf;
        MelhorTemp_Solucao = [];

        for j = 1:Nk %laço interno que controla as iterações

            iteracao_total = iteracao_total + 1; % incrementa a cada iteração
            fprintf("Iteração %d (Temperatura: %.4fºC, Iteração por Temperatura: %d/%d)\n\n", iteracao_total, Temperatura, j, Nk);

            %SolucaoVizinha = GeraSolucaoVizinhaPerturbacaoUniforme(SolucaoAtual, deltaKp, deltaKi, deltaKd, limite_min, limite_max_Kp, limite_max_Ki, limite_max_Kd);
            %SolucaoVizinha = GeraSolucaoVizinhaPerturbacaoGaussiana(SolucaoAtual, limite_min, limite_max_Kp, limite_max_Ki, limite_max_Kd, sigmaKp, sigmaKi, sigmaKd);
            %SolucaoVizinha = GeraSolucaoVizinhaPerturbacaoTriangular(SolucaoAtual, limite_min, limite_max_Kp, limite_max_Ki, limite_max_Kd, deltaKp, deltaKi, deltaKd);
            %SolucaoVizinha = GeraSolucaoVizinhaPerturbacaoCauchy(SolucaoAtual, limite_min, limite_max_Kp, limite_max_Ki, limite_max_Kd, gammaKp, gammaKi, gammaKd);
            [SolucaoVizinha, EstadoAtual] = GeraSolucaoVizinhaMetodoAdaptativo(SolucaoAtual, EstadoAtual, limite_min, limite_max_Kp, limite_max_Ki, limite_max_Kd, deltaKp, deltaKi, deltaKd, sigmaKp, sigmaKi, sigmaKd,gammaKp, gammaKi, gammaKd);

            fprintf("Soluçao vizinha: Kp = %.4f, Ki = %.4f, Kd = %.4f", SolucaoVizinha)

            IAE_vizinha = Simula_Avalia(SolucaoVizinha(1), SolucaoVizinha(2), SolucaoVizinha(3));
            fprintf(" - IAE = %.4f \n", IAE_vizinha)

            % Cálculo do desempenho entre as soluções geradas:
            DeltaF = IAE_vizinha - IAE_atual;
            fprintf("DeltaF = %.4f \n", DeltaF)

            if DeltaF <= 0
                SolucaoAtual = SolucaoVizinha;
                IAE_atual = IAE_vizinha;
                EstadoAtual.IteracoesSemMelhora = 0; %reseta o contador de iterações
                fprintf("Solução vizinha se torna a solução atual\n")
                fprintf("\nNova solução atual: Kp = %.4f, Ki = %.4f, Kd = %.4f", SolucaoAtual)
                fprintf(" - IAE = %.4f \n\n", IAE_atual)
            else
                % calcula a probabilidade de aceitação da solução vizinha
                p = exp(-DeltaF/Temperatura);
                fprintf("Probabilidade de aceitação da solução vizinha: p = %.8f ", p)
                x = rand();
                fprintf("\nNúmero aleatório gerado = %.4f", x)
                if x < p % gera um número entre 0 e 1 e verifica se é menor que a probabilidade
                    SolucaoAtual = SolucaoVizinha;
                    IAE_atual = IAE_vizinha;
                    fprintf("\nSolução vizinha se torna a solução atual\n\n")
                    fprintf("Nova solução atual: Kp = %.4f, Ki = %.4f, Kd = %.4f", SolucaoAtual)
                    fprintf(" - IAE = %.4f \n\n", IAE_atual)
                else
                    % x > p
                    EstadoAtual.IteracoesSemMelhora = EstadoAtual.IteracoesSemMelhora + 1;
                    fprintf("\nNúmero aleatório gerado é maior do que a probabilidade\n\nMantém a solução atual: Kp = %.4f, Ki = %.4f, Kd = %.4f\n\n", SolucaoAtual)
                end
            end

            % para pegar a melhor solução entre todos (o melhor global)
            if IAE_atual < MelhorDesempenho
                MelhorSolucao = SolucaoAtual;
                MelhorDesempenho = IAE_atual;
            end

            % Atualiza melhor da temperatura atual corrente
            if IAE_atual < MelhorTemp_IAE
                MelhorTemp_IAE = IAE_atual;
                MelhorTemp_Solucao = SolucaoAtual;
            end

        end

        % Salva o melhor desta temperatura no histórico
        HistoricoMelhores = [HistoricoMelhores; Temperatura, MelhorTemp_IAE, MelhorTemp_Solucao];

        % atualiza o decaimento da temperatura
        Temperatura = alpha * Temperatura;
        fprintf("\nDiminuição da temperatura para T = %.4fºC \n\n", Temperatura)
        %pause(0.1);
    end
    fprintf("A Temperatura mínima = %.4fºC foi atingida!\n",Temperatura_min)
end


% =================================================================
%       INÍCIO DA SEÇÃO DE AUTOMAÇÃO DE MÚLTIPLOS TESTES
% =================================================================

% Definição dos Parâmetros do Algoritmo
% Estes parâmetros serão os mesmos para todos os testes

% limites para a solução inicial e solução vizinha
limite_min = 0.1; %para kp, ki e kd
limite_max_Kp = 10;
limite_max_Ki = 5;
limite_max_Kd = 3;

% parâmetros do método de perturbação uniforme
deltaKp = 0.1;
deltaKi = 0.07;
deltaKd = 0.05;

% parâmetros do método de perturbação gaussiana
sigmaKp = 0.05;
sigmaKi = 0.04;
sigmaKd = 0.03;

% parâmetros do método de perturbação de Cauchy
gammaKp = 0.07;
gammaKi = 0.04;
gammaKd = 0.03;

% Definição dos parâmetros iniciais do SA
Temperatura = 265;
Temperatura_min = 0.05;
alpha = 0.95;
Nk = 40;

% Configuração da Bateria de Testes
num_testes = 1; % DEFINA AQUI O NÚMERO DE TESTES QUE VOCÊ QUER EXECUTAR
fprintf('====================================================\n');
fprintf('     INICIANDO BATERIA DE %d TESTES DO SIMULATED ANNEALING     \n', num_testes);
fprintf('====================================================\n\n');

% Matriz para armazenar os resultados: [Kp, Ki, Kd, IAE, Tempo_Execucao]
resultados_finais = zeros(num_testes, 5);

% Laço de Execução dos Testes
tempo_total_inicio = tic; % Marca o início de todos os testes

for i = 1:num_testes
    fprintf('------------------- Executando Teste %d de %d -------------------\n', i, num_testes);
    
    tempo_teste_inicio = tic;
    
    % Chama a sua função principal do SA
    [MelhorSolucao, MelhorDesempenho, ~] = SimulatedAnnealing(Temperatura, Temperatura_min, alpha, Nk , limite_min, limite_max_Kp, limite_max_Ki, limite_max_Kd, deltaKp, deltaKi, deltaKd, sigmaKp, sigmaKi, sigmaKd, gammaKp, gammaKi, gammaKd);
    
    tempo_teste_fim = toc(tempo_teste_inicio);
    
    % Armazena o melhor resultado deste teste, incluindo o tempo de execução
    resultados_finais(i, 1) = MelhorSolucao(1); % Kp
    resultados_finais(i, 2) = MelhorSolucao(2); % Ki
    resultados_finais(i, 3) = MelhorSolucao(3); % Kd
    resultados_finais(i, 4) = MelhorDesempenho;  % IAE
    resultados_finais(i, 5) = tempo_teste_fim;   % Tempo de execução
    
    fprintf('\n>> Teste %d concluído. IAE = %.4f (levou %.2f segundos)\n\n', ...
            i, MelhorDesempenho, tempo_teste_fim);
end

tempo_total_fim = toc(tempo_total_inicio);

% Apresentação Final da Matriz de Resultados
fprintf('====================================================\n');
fprintf('           BATERIA DE TESTES FINALIZADA!           \n');
fprintf('====================================================\n\n');

fprintf('Tempo total de execução para %d testes: %.2f segundos.\n\n', num_testes, tempo_total_fim);

% Exibe a matriz final com todos os resultados
disp('Resumo dos melhores resultados de cada teste:');
fprintf('Teste |    Kp    |    Ki    |    Kd    |    IAE   | Tempo (s)\n');
fprintf('-----------------------------------------------------------------\n');
for i = 1:num_testes
    % MODIFICADO: Ajustado o formato para 4 casas decimais na exibição do console
    fprintf('%-5d | %-8.4f | %-8.4f | %-8.4f | %-8.4f | %-9.4f\n', ...
        i, resultados_finais(i,1), resultados_finais(i,2), resultados_finais(i,3), resultados_finais(i,4), resultados_finais(i,5));
end


% Salvar a matriz de resultados em um arquivo Excel sem sobrescrever
nome_arquivo = 'resultados_completos_SA.xlsx';
fprintf('\nSalvando resultados no arquivo "%s"...\n', nome_arquivo);

% Nomes das colunas para a tabela
headers = {'ID_Teste', 'Kp', 'Ki', 'Kd', 'IAE', 'Tempo_de_execução'};

% Variável para guardar o número do último teste salvo no arquivo
ultimo_id_teste = 0;

% Verifica se o arquivo já existe para ler os dados antigos
if exist(nome_arquivo, 'file') == 2
    try
        % Se o arquivo existir, lê a tabela antiga
        tabela_antiga = readtable(nome_arquivo);
        
        % Verifica se a tabela não está vazia e tem a coluna 'ID_Teste'
        if ~isempty(tabela_antiga) && ismember('ID_Teste', tabela_antiga.Properties.VariableNames)
             % Pega o maior ID da tabela antiga para continuar a contagem
            ultimo_id_teste = max(tabela_antiga.ID_Teste);
        end
        
        fprintf('Arquivo existente encontrado. Adicionando novos resultados ao final.\n');
        
    catch ME
        % Em caso de erro ao ler (ex: arquivo corrompido), avisa o usuário
        warning('Não foi possível ler o arquivo existente. Um novo arquivo será criado. Erro: %s', ME.message);
        tabela_antiga = table(); % Cria uma tabela vazia para evitar erros
    end
else
    % Se o arquivo não existe, cria uma tabela vazia para iniciar
    tabela_antiga = table();
    fprintf('Arquivo não encontrado. Criando um novo arquivo para salvar os resultados.\n');
end

% Cria a coluna com os novos IDs dos testes
novos_ids = (ultimo_id_teste + 1 : ultimo_id_teste + num_testes)';

% ==============================================================================
% >>>>> ALTERAÇÃO PRINCIPAL AQUI <<<<<
% Arredonda a matriz de resultados para 4 casas decimais antes de salvar
resultados_arredondados = round(resultados_finais, 4);
% ==============================================================================

% Cria uma nova tabela com os resultados ARREDONDADOS desta execução
tabela_nova = array2table([novos_ids, resultados_arredondados], 'VariableNames', headers);

% Combina a tabela antiga com a nova
tabela_completa = [tabela_antiga; tabela_nova];

% Salva a tabela completa no arquivo Excel (sobrescrevendo com os dados combinados)
writetable(tabela_completa, nome_arquivo);

fprintf('Resultados salvos com sucesso!\n');
fprintf('\nFim da execução.\n');