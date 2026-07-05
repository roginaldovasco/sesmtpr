/*
# Schema Inicial - Sistema de Cadastro de Acidentes e Incidentes de Trabalho

1. Novas Tabelas
- `profiles`: armazena dados adicionais do usuário (nome, cargo)
- `empresas`: cadastro de empresas
- `estabelecimentos`: cadastro de estabelecimentos vinculados a empresas
- `setores`: cadastro de setores vinculados a estabelecimentos
- `registros_ocorrencias`: registro de acidentes e incidentes de trabalho

2. Hierarquia
- Empresas -> Estabelecimentos -> Setores -> Registros de Ocorrências

3. Segurança
- RLS habilitado em todas as tabelas
- Políticas para usuários autenticados gerenciarem seus próprios dados
- user_id com DEFAULT auth.uid() para inserts automáticos
*/

-- Tabela de perfis de usuário
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  nome text NOT NULL,
  cargo text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_profile" ON profiles;
CREATE POLICY "select_own_profile" ON profiles FOR SELECT
  TO authenticated USING (auth.uid() = id);

DROP POLICY IF EXISTS "insert_own_profile" ON profiles;
CREATE POLICY "insert_own_profile" ON profiles FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "update_own_profile" ON profiles;
CREATE POLICY "update_own_profile" ON profiles FOR UPDATE
  TO authenticated USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

-- Tabela de empresas
CREATE TABLE IF NOT EXISTS empresas (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nome text NOT NULL,
  cnpj text UNIQUE,
  telefone text,
  email text,
  endereco text,
  ativo boolean DEFAULT true,
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE empresas ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_empresas" ON empresas;
CREATE POLICY "select_own_empresas" ON empresas FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_empresas" ON empresas;
CREATE POLICY "insert_own_empresas" ON empresas FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_empresas" ON empresas;
CREATE POLICY "update_own_empresas" ON empresas FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_empresas" ON empresas;
CREATE POLICY "delete_own_empresas" ON empresas FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- Tabela de estabelecimentos
CREATE TABLE IF NOT EXISTS estabelecimentos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nome text NOT NULL,
  cnpj text,
  empresa_id uuid NOT NULL REFERENCES empresas(id) ON DELETE CASCADE,
  endereco text,
  cidade text,
  estado varchar(2),
  ativo boolean DEFAULT true,
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE estabelecimentos ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_estabelecimentos" ON estabelecimentos;
CREATE POLICY "select_own_estabelecimentos" ON estabelecimentos FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_estabelecimentos" ON estabelecimentos;
CREATE POLICY "insert_own_estabelecimentos" ON estabelecimentos FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_estabelecimentos" ON estabelecimentos;
CREATE POLICY "update_own_estabelecimentos" ON estabelecimentos FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_estabelecimentos" ON estabelecimentos;
CREATE POLICY "delete_own_estabelecimentos" ON estabelecimentos FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- Tabela de setores
CREATE TABLE IF NOT EXISTS setores (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nome text NOT NULL,
  estabelecimento_id uuid NOT NULL REFERENCES estabelecimentos(id) ON DELETE CASCADE,
  descricao text,
  ativo boolean DEFAULT true,
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE setores ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_setores" ON setores;
CREATE POLICY "select_own_setores" ON setores FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_setores" ON setores;
CREATE POLICY "insert_own_setores" ON setores FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_setores" ON setores;
CREATE POLICY "update_own_setores" ON setores FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_setores" ON setores;
CREATE POLICY "delete_own_setores" ON setores FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- Tabela de registros de ocorrências
CREATE TABLE IF NOT EXISTS registros_ocorrencias (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  data_ocorrencia date NOT NULL,
  tipo text NOT NULL CHECK (tipo IN ('Acidente', 'Incidente')),
  nome_colaborador text NOT NULL,
  genero text NOT NULL CHECK (genero IN ('Masculino', 'Feminino')),
  data_nascimento date NOT NULL,
  data_admissao date NOT NULL,
  tempo_empresa text,
  dias_afastamento integer DEFAULT 0,
  setor_id uuid REFERENCES setores(id) ON DELETE SET NULL,
  lider text,
  conclusao text CHECK (conclusao IN ('Ato Inseguro', 'Condição Insegura')),
  descricao text,
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE registros_ocorrencias ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_registros" ON registros_ocorrencias;
CREATE POLICY "select_own_registros" ON registros_ocorrencias FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_registros" ON registros_ocorrencias;
CREATE POLICY "insert_own_registros" ON registros_ocorrencias FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_registros" ON registros_ocorrencias;
CREATE POLICY "update_own_registros" ON registros_ocorrencias FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_registros" ON registros_ocorrencias;
CREATE POLICY "delete_own_registros" ON registros_ocorrencias FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- Índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_estabelecimentos_empresa ON estabelecimentos(empresa_id);
CREATE INDEX IF NOT EXISTS idx_setores_estabelecimento ON setores(estabelecimento_id);
CREATE INDEX IF NOT EXISTS idx_registros_setor ON registros_ocorrencias(setor_id);
CREATE INDEX IF NOT EXISTS idx_registros_tipo ON registros_ocorrencias(tipo);
CREATE INDEX IF NOT EXISTS idx_registros_data ON registros_ocorrencias(data_ocorrencia);
CREATE INDEX IF NOT EXISTS idx_empresas_user ON empresas(user_id);
CREATE INDEX IF NOT EXISTS idx_estabelecimentos_user ON estabelecimentos(user_id);
CREATE INDEX IF NOT EXISTS idx_setores_user ON setores(user_id);
CREATE INDEX IF NOT EXISTS idx_registros_user ON registros_ocorrencias(user_id);
