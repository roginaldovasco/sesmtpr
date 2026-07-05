export interface Profile {
  id: string;
  nome: string;
  cargo: string | null;
  created_at: string;
  updated_at: string;
}

export interface Empresa {
  id: string;
  nome: string;
  cnpj: string | null;
  telefone: string | null;
  email: string | null;
  endereco: string | null;
  ativo: boolean;
  user_id: string;
  created_at: string;
  updated_at: string;
}

export interface Estabelecimento {
  id: string;
  nome: string;
  cnpj: string | null;
  empresa_id: string;
  endereco: string | null;
  cidade: string | null;
  estado: string | null;
  ativo: boolean;
  user_id: string;
  created_at: string;
  updated_at: string;
  empresa?: Empresa;
}

export interface Setor {
  id: string;
  nome: string;
  estabelecimento_id: string;
  descricao: string | null;
  ativo: boolean;
  user_id: string;
  created_at: string;
  updated_at: string;
  estabelecimento?: Estabelecimento;
}

export interface RegistroOcorrencia {
  id: string;
  data_ocorrencia: string;
  tipo: 'Acidente' | 'Incidente';
  nome_colaborador: string;
  genero: 'Masculino' | 'Feminino';
  data_nascimento: string;
  data_admissao: string;
  tempo_empresa: string | null;
  dias_afastamento: number;
  setor_id: string | null;
  lider: string | null;
  conclusao: 'Ato Inseguro' | 'Condição Insegura' | null;
  descricao: string | null;
  user_id: string;
  created_at: string;
  updated_at: string;
  setor?: Setor;
}

export type EmpresaInsert = Omit<Empresa, 'id' | 'user_id' | 'created_at' | 'updated_at'>;
export type EstabelecimentoInsert = Omit<Estabelecimento, 'id' | 'user_id' | 'created_at' | 'updated_at' | 'empresa'>;
export type SetorInsert = Omit<Setor, 'id' | 'user_id' | 'created_at' | 'updated_at' | 'estabelecimento'>;
export type RegistroOcorrenciaInsert = Omit<RegistroOcorrencia, 'id' | 'user_id' | 'created_at' | 'updated_at' | 'setor'>;
