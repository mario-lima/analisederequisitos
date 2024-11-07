-- 1. Tabela de Usuários: Cadastro básico para usuários com login via SSO (Gov.br).
CREATE TABLE Usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    email VARCHAR(100),
    telefone VARCHAR(15),
    cargo ENUM('Perito', 'Comandante', 'Solicitante', 'Operador') NOT NULL,
    govbr_id VARCHAR(50) UNIQUE NOT NULL -- ID único do SSO Gov.br
);

-- 2. Tabela de Chamados: Registra chamados, integrando com sistema do corpo de bombeiros, e armazenando endereço e localização.
CREATE TABLE Chamados (
    id_chamado INT PRIMARY KEY AUTO_INCREMENT,
    id_solicitante INT NOT NULL,
    data_hora_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Aberto', 'Encaminhado', 'Laudo Recebido', 'Aprovado', 'Reprovado') DEFAULT 'Aberto',
    sla INT, -- Em horas
    localizacao_lat DECIMAL(10, 8), -- Latitude para geolocalização
    localizacao_long DECIMAL(11, 8), -- Longitude para geolocalização
    cep VARCHAR(8),
    endereco VARCHAR(200),
    FOREIGN KEY (id_solicitante) REFERENCES Usuarios(id_usuario)
);

-- 3. Tabela de Peritos: Cadastro específico dos peritos ativos, associando-os aos chamados.
CREATE TABLE Peritos (
    id_perito INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

-- 4. Tabela de Laudos: Armazena laudos periciais associados aos chamados, com fotos e assinatura digital.
CREATE TABLE Laudos (
    id_laudo INT PRIMARY KEY AUTO_INCREMENT,
    id_chamado INT NOT NULL,
    id_perito INT NOT NULL,
    data_hora_pericia DATETIME NOT NULL,
    descricao TEXT,
    assinatura_digital VARCHAR(255),
    status ENUM('Pendente', 'Concluído') DEFAULT 'Pendente',
    FOREIGN KEY (id_chamado) REFERENCES Chamados(id_chamado),
    FOREIGN KEY (id_perito) REFERENCES Peritos(id_perito)
);

-- 5. Tabela de Fotos: Armazena fotos capturadas durante a perícia.
CREATE TABLE Fotos (
    id_foto INT PRIMARY KEY AUTO_INCREMENT,
    id_laudo INT NOT NULL,
    url_foto VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_laudo) REFERENCES Laudos(id_laudo)
);

-- 6. Tabela de Atualizações de Status: Registra histórico de mudanças de status dos chamados.
CREATE TABLE AtualizacoesStatus (
    id_status INT PRIMARY KEY AUTO_INCREMENT,
    id_chamado INT NOT NULL,
    status ENUM('Aberto', 'Encaminhado', 'Laudo Recebido', 'Aprovado', 'Reprovado') NOT NULL,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_responsavel INT NOT NULL,
    FOREIGN KEY (id_chamado) REFERENCES Chamados(id_chamado),
    FOREIGN KEY (id_responsavel) REFERENCES Usuarios(id_usuario)
);

-- 7. Tabela de Notificações: Armazena notificações do sistema para acompanhamento.
CREATE TABLE Notificacoes (
    id_notificacao INT PRIMARY KEY AUTO_INCREMENT,
    id_chamado INT,
    tipo ENUM('Encaminhamento', 'Laudo Recebido', 'Status Atualizado'),
    mensagem VARCHAR(255),
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    destinatario_id INT,
    FOREIGN KEY (id_chamado) REFERENCES Chamados(id_chamado),
    FOREIGN KEY (destinatario_id) REFERENCES Usuarios(id_usuario)
);
