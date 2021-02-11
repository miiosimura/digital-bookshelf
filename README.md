# Estante Digital
A aplicação consiste em um sistema de livros simples. Usuários podem acessar e buscar livros, e administradores podem cadastrar, editar e excluir livros.

# Aplicação

Foi realizado o deploy da aplicação no Heroku, que pode ser acessado através do link: https://estante-digital.herokuapp.com/

# Subindo o projeto
* `git clone git@github.com:miiosimura/codejobs.git`
* A versão do ruby usada no projeto é a 2.6.6, troque a versão ou instale
* A versão do node usada no projeto é a 14.0.0, troque a versão ou instale
* `bundle install`
* `yarn install --check-files`
* `rails db:create`
* `rails db:migrate`
* `rails db:seed`
* `rails s` e acesse `http://localhost:3000/`
* Para logar como admin, acesse: `http://localhost:3000/admins/sign_in`
  * Login: admin@email.com, Senha: 123456

# Rodando os testes
* A cobertura de teste é feita com o SimpleCov. Para gerar o relatório, primeiramente é preciso rodar `coverage=on rspec .`
* Com isso será possível acessar a interface do SimpleCov, rodando:
  * Para Mac: `open coverage/index.html`
  * Para Debian/Ubuntu `xdg-open coverage/index.html`