# CRUD de Despesas

## Descrição

Este é um aplicativo de controle de despesas pessoais desenvolvido com **Flutter** e **Firebase**. O projeto utiliza a arquitetura **MVVM** para organização de código e gerenciamento de dados, oferecendo funcionalidades para **adicionar**, **visualizar**, **editar** e **excluir** despesas, além de relatórios mensais detalhados.

---

## 📑 Estrutura de pastas

```plaintext
lib/
├── views/
│   ├── adicionar_despesa.dart
│   ├── relatorio_despesas.dart
│   └── home.dart
├── models/
│   └── despesa.dart
├── viewmodels/
│   └── despesa_viewmodel.dart
└── main.dart
```

---

## 🔧 Funcionalidades

- **Adicionar despesa**: o usuário pode adicionar novas despesas, especificando título, valor, categoria e se há renovação automática;
- **Visualizar relatório**: exibe todas as despesas do mês corrente em ordem decrescente de data;
- **Editar e excluir despesa**: permite a edição ou exclusão das despesas diretamente no Firebase,
- **Cálculo de total mensal**: mostra o total de despesas acumulado no mês atual.

---

## 📊 Regras de negócio

- As despesas devem possuir um título, valor, categoria e data;
- O campo valor deve ser numérico e maior que zero;
- O total do mês é calculado somando todas as despesas do mês atual;
- Apenas as despesas do mês atual são exibidas no relatório.

---

## ⚙️ Tecnologias utilizadas

- **Flutter**: Framework para desenvolvimento multiplataforma;
- **Firebase Firestore**: banco de dados NoSQL para armazenamento de despesas;
- **Arquitetura MVVM**: separação entre camada de apresentação e camada de dados.

---

## 🚀 Instalação

Para instalar o projeto localmente, siga os passos abaixo:

1. Clone o repositório:
   ```bash
   git clone https://github.com/bredlxy/CRUDespesas.git
   cd CRUDespesas
   ```
2. Instale as dependências do Flutter:
   ```bash
   flutter pub get
   ```
3. Configure o Firebase para Android, iOS ou Web conforme as instruções no site oficial.

4. Execute o projeto:
   ```bash
   flutter run
   ```

---

## 📝 Documentação

A documentação completa do projeto está disponível na pasta docs, incluindo o relatório detalhado, o arquivo de instruções do projeto e um vídeo de demonstração.

---

- [Bredley Bauer](https://github.com/bredlxy)
