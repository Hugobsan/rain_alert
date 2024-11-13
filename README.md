# Rain Alert

Rain Alert é um aplicativo de previsão do tempo que fornece informações meteorológicas em tempo real com base na localização do usuário e permite monitorar diversas cidades ao mesmo tempo. Além disso, o aplicativo oferece notificações e histórico de alertas meteorológicos, ajudando os usuários a se manterem informados sobre mudanças significativas no clima.

## Funcionalidades

- **Previsão do Tempo em Tempo Real**:
  - Exibe a temperatura atual, condições climáticas (céu limpo, chuva, etc.), temperatura mínima e máxima do dia.
  - Atualiza automaticamente os dados com base na localização atual do usuário.

- **Lista de Cidades Favoritas**:
  - Permite que o usuário adicione múltiplas cidades para acompanhar o clima de diferentes locais.
  - As cidades são salvas e sincronizadas para usuários autenticados, possibilitando o acesso entre dispositivos.

- **Notificações Meteorológicas**:
  - Envia notificações para alertar o usuário sobre mudanças climáticas significativas, como chuvas intensas, tempestades ou aumento de temperatura.
  - Histórico de notificações: o usuário pode revisar alertas meteorológicos recebidos anteriormente.

- **Configurações Personalizadas**:
  - O usuário pode configurar preferências de notificação e ajustes de exibição.
  - Opção de login/logout para sincronização dos dados salvos, como cidades favoritas e configurações.

## Recursos Externos Utilizados

- **OpenWeatherMap API**:
  - API externa para obter dados meteorológicos em tempo real. Utilizada para consultar informações como temperatura, condições do tempo e previsão para dias futuros.

- **Firebase**:
  - **Firebase Auth**: Autenticação de usuário para acesso opcional ao aplicativo. Usuários logados podem salvar suas cidades e configurações para acesso sincronizado entre dispositivos.
  - **Cloud Firestore**: Armazena cidades favoritas e histórico de notificações para cada usuário, oferecendo um acesso rápido e eficiente.
  - **Firebase Messaging**: Envia notificações meteorológicas personalizadas com base nas preferências e na localização do usuário.

- **Geolocator**:
  - Serviço de geolocalização que captura a localização atual do usuário para fornecer automaticamente a previsão do tempo para o local em que ele se encontra.

- **flutter_dotenv**:
  - Utilizado para armazenar de forma segura a chave de API da OpenWeatherMap em um arquivo `.env`, evitando exposição direta de informações sensíveis no código.

## Tecnologias Utilizadas

- **Flutter**: Framework principal para desenvolvimento da interface do usuário e navegação.
- **Provider**: Gerenciamento de estado para facilitar a injeção de dependências e compartilhamento de dados entre componentes.
- **HTTP**: Biblioteca para requisições HTTP, utilizada para acessar a API da OpenWeatherMap.

## Estrutura do Projeto

- `lib/`
  - `app/`: Contém a configuração principal do aplicativo (`AppWidget`).
  - `modules/`: Dividido em módulos como `home`, `splash`, `settings`, `notifications`, `auth`, e `add_city`.
  - `shared/services/`: Serviços reutilizáveis, como `GeolocatorService` e `WeatherService`, que encapsulam a lógica de comunicação com APIs e geolocalização.
  - `shared/models/`: Modelos de dados que representam entidades como `User`, `Weather`, e `City`.
  - `shared/widgets/`: Widgets customizados reutilizáveis, como botões e carregadores personalizados.

## Configuração Inicial

1. **Configurar a Chave de API**:
   - Crie um arquivo `.env` na raiz do projeto com a seguinte estrutura:
     ```env
     OPENWEATHER_API_KEY=your_api_key_here
     ```

2. **Instalar Dependências**:
   - Execute o comando `flutter pub get` para instalar todas as dependências listadas no `pubspec.yaml`.

3. **Executar o App**:
   - Execute `flutter run` para iniciar o aplicativo.

## Contribuição

Sinta-se à vontade para contribuir com melhorias, ajustes de código e novas funcionalidades. Faça um fork do repositório, realize suas mudanças e abra uma pull request.

## Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.
