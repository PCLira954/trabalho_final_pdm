# trabalho_final_dpm
Gasolina Fácil — App Flutter para cadastro de postos de gasolina e visualização em mapa com geolocalização.

📄 Descrição

Projeto de disciplina que permite cadastrar "postos de gasolina" com nome, telefone, email (opcional), latitude e longitude — manualmente ou pela localização atual do dispositivo.
No mapa, o app exibe marcadores para cada posto cadastrado, além de permitir ver a localização atual do usuário.

Serve como um app de demonstração de uso de Flutter + persistência local (Hive) + Google Maps + geolocalização.

✅ Funcionalidades

Autenticação de usuário (login / cadastro)

Tela de cadastro de postos de gasolina (nome, telefone, email, latitude, longitude)

Opção de “Usar localização atual” para preencher latitude/longitude automaticamente (via GPS)

Listagem de postos cadastrados

Edição e exclusão de postos

Mapa com marcadores correspondentes aos postos

Visualização da localização atual do usuário no mapa

Salvamento persistente de dados usando Hive

🛠️ Tecnologias / Pacotes utilizados

Flutter — framework para o app móvel

hive & hive_flutter — armazenamento local (persistência simples)

google_maps_flutter — para exibir mapas e marcadores

geolocator — para obter localização do dispositivo

provider — gerenciamento de estado (controllers)

uuid — geração de IDs únicos para postos

flutter_secure_storage — (caso use autenticação com armazenamento seguro)

/lib
  /models
    contact.dart
    contact_hive.dart
  /controllers
    contact_controller.dart
    auth_controller.dart
  /services
    db_service.dart
  /views
    login_view.dart
    register_view.dart
    contacts_view.dart
    contact_form.dart  ← formulário para adicionar/editar posto com lat/lng
    map_view.dart      ← tela de mapa que exibe a localização e marcadores
main.dart             ← ponto de entrada do app
pubspec.yaml          ← dependências do projeto

