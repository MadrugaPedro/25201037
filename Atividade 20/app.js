/**
 * Este script gerencia:
 * 1. Consumo dos dados via Fetch API
 * 2. Alternância entre as duas abordagens didáticas:
 *    - Abordagem 1: Regra de aprovação calculada no JavaScript
 *    - Abordagem 2 (Final): Regra de aprovação calculada no Backend PHP
 * 3. Renderização dinâmica da tabela HTML
 * 4. Cálculo das estatísticas da turma
 * 5. Cadastro de novos alunos via requisição POST
 * 6. Fallback gracioso com dados de demonstração offline
 */


const appState = {
    abordagem: 2, 
    alunos: [],
    carregando: false,
    modoOffline: false
};


const DADOS_DEMO = [
    { id: 1, nome: 'Ana Souza', nota: 8.50 },
    { id: 2, nome: 'Bruno Lima', nota: 6.00 },
    { id: 3, nome: 'Carlos Mendes', nota: 7.00 },
    { id: 4, nome: 'Daniel Oliveira', nota: 5.50 },
    { id: 5, nome: 'Eduarda Santos', nota: 9.00 },
    { id: 6, nome: 'Felipe Albuquerque', nota: 6.80 }
];


const dom = {
    tabelaCorpo: document.getElementById('tabela-alunos-corpo'),
    loadingState: document.getElementById('loading-state'),
    emptyState: document.getElementById('empty-state'),
    errorAlert: document.getElementById('error-alert'),
    btnRefresh: document.getElementById('btn-refresh'),
    formAluno: document.getElementById('form-aluno'),
    inputNome: document.getElementById('aluno-nome'),
    inputNota: document.getElementById('aluno-nota'),
    btnCadastrar: document.getElementById('btn-cadastrar'),
    btnTabJs: document.getElementById('tab-approach-js'),
    btnTabPhp: document.getElementById('tab-approach-php'),
    flowStepsContainer: document.getElementById('flow-steps-container'),
    totalAlunos: document.getElementById('stat-total'),
    mediaTurma: document.getElementById('stat-media'),
    totalAprovados: document.getElementById('stat-aprovados'),
    totalReprovados: document.getElementById('stat-reprovados'),
    accordionToggle: document.getElementById('accordion-toggle'),
    accordionWrapper: document.getElementById('accordion-theory')
};


document.addEventListener('DOMContentLoaded', () => {
    configurarEventos();
    carregarAlunos();
});

function configurarEventos() {
    
    dom.btnTabJs.addEventListener('click', () => trocarAbordagem(1));
    dom.btnTabPhp.addEventListener('click', () => trocarAbordagem(2));

   
    dom.btnRefresh.addEventListener('click', () => carregarAlunos());

    
    dom.formAluno.addEventListener('submit', cadastrarAluno);

   
    if (dom.accordionToggle && dom.accordionWrapper) {
        dom.accordionToggle.addEventListener('click', () => {
            dom.accordionWrapper.classList.toggle('open');
            const icon = dom.accordionToggle.querySelector('.toggle-icon');
            if (icon) {
                icon.textContent = dom.accordionWrapper.classList.contains('open') ? '▲' : '▼';
            }
        });
    }
}


function trocarAbordagem(novaAbordagem) {
    if (appState.abordagem === novaAbordagem) return;

    appState.abordagem = novaAbordagem;

    if (novaAbordagem === 1) {
        dom.btnTabJs.classList.add('active');
        dom.btnTabPhp.classList.remove('active');
        atualizarDiagramaFluxo(1);
    } else {
        dom.btnTabPhp.classList.add('active');
        dom.btnTabJs.classList.remove('active');
        atualizarDiagramaFluxo(2);
    }

    carregarAlunos();
}

function atualizarDiagramaFluxo(abordagem) {
    if (abordagem === 1) {
        dom.flowStepsContainer.innerHTML = `
            <span class="flow-step">Banco MySQL</span>
            <span class="flow-arrow">➔</span>
            <span class="flow-step">PHP (SELECT bruto)</span>
            <span class="flow-arrow">➔</span>
            <span class="flow-step">JSON sem status</span>
            <span class="flow-arrow">➔</span>
            <span class="flow-step highlight">⚡ JavaScript calcula status (nota &gt;= 7)</span>
            <span class="flow-arrow">➔</span>
            <span class="flow-step">Tabela HTML</span>
        `;
    } else {
        dom.flowStepsContainer.innerHTML = `
            <span class="flow-step">Banco MySQL</span>
            <span class="flow-arrow">➔</span>
            <span class="flow-step highlight">⚙️ PHP calcula status ($nota &gt;= 7)</span>
            <span class="flow-arrow">➔</span>
            <span class="flow-step">JSON com "status" pronto</span>
            <span class="flow-arrow">➔</span>
            <span class="flow-step">JavaScript (apenas consome e exibe)</span>
            <span class="flow-arrow">➔</span>
            <span class="flow-step">Tabela HTML</span>
        `;
    }
}


function carregarAlunos() {
    setLoading(true);
    ocultarErro();

    
    const endpoint = (appState.abordagem === 1) 
        ? 'api/alunos_v1.php' 
        : 'api/alunos.php';

    fetch(endpoint)
        .then(response => {
            if (!response.ok) {
                throw new Error(`Erro na resposta do servidor (HTTP ${response.status})`);
            }
            return response.json();
        })
        .then(alunos => {
            appState.modoOffline = false;
            processarERenderizarAlunos(alunos);
        })
        .catch(erro => {
            console.warn('Aviso: Falha ao conectar com o backend PHP/MySQL:', erro);
            // Ativa fallback gracioso para não travar a visualização
            ativarModoDemonstrativo(erro.message);
        })
        .finally(() => {
            setLoading(false);
        });
}


function processarERenderizarAlunos(dados) {
    let alunosProcessados = [];

    if (appState.abordagem === 1) {
       
        alunosProcessados = dados.map(aluno => {
            const nota = parseFloat(aluno.nota);
            // Requisito 6 do Roteiro:
            const status = nota >= 7.0 ? 'Aprovado' : 'Reprovado';

            return {
                id: aluno.id,
                nome: aluno.nome,
                nota: nota,
                status: status,
                origemRegra: 'JavaScript (Frontend)'
            };
        });
    } else {
       
        alunosProcessados = dados.map(aluno => {
            return {
                id: aluno.id,
                nome: aluno.nome,
                nota: parseFloat(aluno.nota),
                status: aluno.status || (parseFloat(aluno.nota) >= 7.0 ? 'Aprovado' : 'Reprovado'),
                origemRegra: 'PHP (Backend)'
            };
        });
    }

    appState.alunos = alunosProcessados;
    renderizarTabela(alunosProcessados);
    atualizarEstatisticas(alunosProcessados);
}


function renderizarTabela(alunos) {
    dom.tabelaCorpo.innerHTML = '';

    if (!alunos || alunos.length === 0) {
        dom.emptyState.style.display = 'block';
        return;
    }
    dom.emptyState.style.display = 'none';

    alunos.forEach(aluno => {
        const tr = document.createElement('tr');

        
        const inicial = aluno.nome ? aluno.nome.charAt(0).toUpperCase() : '?';

       
        const notaFormatada = aluno.nota.toFixed(2).replace('.', ',');

       
        const isAprovado = aluno.status === 'Aprovado';
        const badgeClasse = isAprovado ? 'aprovado' : 'reprovado';
        const iconeStatus = isAprovado ? '✓' : '✗';

        tr.innerHTML = `
            <td>#${aluno.id}</td>
            <td>
                <div class="student-name">
                    <span class="avatar">${inicial}</span>
                    <span>${escapeHtml(aluno.nome)}</span>
                </div>
            </td>
            <td>
                <span class="grade-pill">${notaFormatada}</span>
            </td>
            <td>
                <div>
                    <span class="status-badge ${badgeClasse}">
                        ${iconeStatus} ${aluno.status}
                    </span>
                    <span class="badge-source">Calculado via ${aluno.origemRegra}</span>
                </div>
            </td>
        `;

        dom.tabelaCorpo.appendChild(tr);
    });
}


function atualizarEstatisticas(alunos) {
    const total = alunos.length;

    if (total === 0) {
        dom.totalAlunos.textContent = '0';
        dom.mediaTurma.textContent = '0,0';
        dom.totalAprovados.textContent = '0';
        dom.totalReprovados.textContent = '0';
        return;
    }

    const somaNotas = alunos.reduce((acc, a) => acc + a.nota, 0);
    const media = somaNotas / total;
    const aprovados = alunos.filter(a => a.status === 'Aprovado').length;
    const reprovados = total - aprovados;

    dom.totalAlunos.textContent = total;
    dom.mediaTurma.textContent = media.toFixed(1).replace('.', ',');
    dom.totalAprovados.textContent = `${aprovados} (${Math.round((aprovados/total)*100)}%)`;
    dom.totalReprovados.textContent = `${reprovados} (${Math.round((reprovados/total)*100)}%)`;
}


function cadastrarAluno(e) {
    e.preventDefault();

    const nome = dom.inputNome.value.trim();
    const notaValor = dom.inputNota.value.trim();
    const nota = parseFloat(notaValor);

    if (!nome) {
        alert('Por favor, informe o nome do aluno.');
        dom.inputNome.focus();
        return;
    }

    if (isNaN(nota) || nota < 0 || nota > 10) {
        alert('A nota deve estar entre 0.0 e 10.0.');
        dom.inputNota.focus();
        return;
    }

    dom.btnCadastrar.disabled = true;
    dom.btnCadastrar.textContent = 'Salvando...';

    
    if (appState.modoOffline) {
        setTimeout(() => {
            const novoAlunoDemo = {
                id: appState.alunos.length + 1,
                nome: nome,
                nota: nota
            };
            DADOS_DEMO.push(novoAlunoDemo);
            processarERenderizarAlunos(DADOS_DEMO);
            limparFormulario();
            alert('Aluno cadastrado na simulação local com sucesso!');
        }, 300);
        return;
    }

    
    fetch('api/alunos.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ nome, nota })
    })
    .then(response => {
        if (!response.ok) {
            return response.json().then(err => { throw new Error(err.mensagem || 'Falha no cadastro'); });
        }
        return response.json();
    })
    .then(data => {
        limparFormulario();
        carregarAlunos();
    })
    .catch(erro => {
        alert('Erro ao cadastrar aluno: ' + erro.message);
    })
    .finally(() => {
        dom.btnCadastrar.disabled = false;
        dom.btnCadastrar.textContent = 'Adicionar Aluno';
    });
}

function limparFormulario() {
    dom.inputNome.value = '';
    dom.inputNota.value = '';
    dom.btnCadastrar.disabled = false;
    dom.btnCadastrar.textContent = 'Adicionar Aluno';
}


function setLoading(ativo) {
    appState.carregando = ativo;
    dom.loadingState.style.display = ativo ? 'block' : 'none';
    if (ativo) {
        dom.emptyState.style.display = 'none';
    }
}

function ativarModoDemonstrativo(mensagemOriginal) {
    appState.modoOffline = true;
    dom.errorAlert.style.display = 'block';
    dom.errorAlert.innerHTML = `
        <div>
            <strong>Aviso de Conexão com o Servidor PHP / MySQL:</strong><br>
            Não foi possível comunicar com o backend local (<code>${escapeHtml(mensagemOriginal)}</code>).<br>
            <span style="font-size: 0.85rem; opacity: 0.9;">
                Para rodar conectado ao MySQL real, certifique-se de iniciar o Apache e MySQL (ex: no XAMPP ou <code>php -S localhost:8000</code>).
                <br>Exibindo <strong>dados demonstrativos simulados</strong> para você testar a interface e alternar entre as abordagens normalmente!
            </span>
        </div>
    `;

    
    let dadosSimulados = JSON.parse(JSON.stringify(DADOS_DEMO));
    if (appState.abordagem === 2) {
        dadosSimulados = dadosSimulados.map(a => ({
            ...a,
            status: a.nota >= 7.0 ? 'Aprovado' : 'Reprovado'
        }));
    }

    processarERenderizarAlunos(dadosSimulados);
}

function ocultarErro() {
    dom.errorAlert.style.display = 'none';
}

function escapeHtml(texto) {
    const div = document.createElement('div');
    div.textContent = texto;
    return div.innerHTML;
}
