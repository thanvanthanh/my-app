# my-app 🚀

A modern iOS application built with **SwiftUI**, **The Composable Architecture (TCA)**, and **Swift Concurrency**. Dependencies are fully managed via **Swift Package Manager (SPM)**, and project generation is automated using **XcodeGen**.

---

## 🛠️ Tech Stack & Architecture

- **UI Framework**: SwiftUI (iOS 16.0+)
- **Architecture & State Management**: [The Composable Architecture (TCA)](https://github.com/pointfreeco/swift-composable-architecture) 1.26.2
- **Navigation Flow**: [TCACoordinators](https://github.com/johnpatrickmorgan/TCACoordinators) with isolated screen features and a high-level coordinator (`TCARouter`, `routes`, `forEachRoute`).
- **Dependency Management**: Swift Package Manager (SPM) integrated directly inside `project.yml`.
- **Concurrency**: 100% modern Swift Concurrency (`async/await`, `Task`, `Sendable`, `ContinuousClock`).
- **Project Generator**: [XcodeGen](https://github.com/yonaskolb/XcodeGen) — generated `.xcodeproj` files are not checked into Git.
- **Code Generation**: [SwiftGen](https://github.com/SwiftGen/SwiftGen) with custom Stencil templates.
- **CLI Tool Management**: [Mint](https://github.com/yonaskolb/mint).
- **CI/CD & Automation**: GitHub Actions for lint/tests; [Fastlane](https://fastlane.tools) for signed deployments.
- **Networking**: [Alamofire](https://github.com/Alamofire/Alamofire) 5.12.0 (async/await).
- **UI Libraries**: [Lottie-SPM](https://github.com/airbnb/lottie-spm), [SDWebImage](https://github.com/SDWebImage/SDWebImage).

---

## 📁 Project Structure

The project follows the **File Separation Pattern**, with screen features kept isolated and navigation coordinated cleanly:

```
Sources/
├── App/                                 # App Entry & Navigation Coordination
│   ├── MyApp.swift                      # SwiftUI @main entry point; wires coordinator and app splash
│   ├── AppDelegate.swift                # UIApplicationDelegate (Lifecycle, Reachability)
│   ├── Composition/                     # App-level TCA dependency wiring
│   │   └── SearchUsersDependency.swift  # Live/test SearchUsersUseCase registration
│   ├── LaunchSplash/                    # Animated in-app launch transition
│   │   ├── AppLaunchSplashConfig.swift  # Timing, color, accessibility, and view modifier
│   │   └── SystemSplashLogo.swift       # SwiftUI logo shared by the transition
│   └── Coordinator/                     # App Coordinator managing app-level navigation flow
│       ├── Screen.swift                 # Screen enum (@Reducer): search, detail
│       ├── AppCoordinatorState.swift    # routes: [Route<Screen.State>]
│       ├── AppCoordinatorAction.swift   # router: IndexedRouterActionOf<Screen>
│       ├── AppCoordinator.swift         # Handles child delegate actions & pushes via forEachRoute
│       └── AppCoordinatorView.swift     # TCARouter mapping screens to Views
│
├── Presentation/                        # Presentation Layer (SwiftUI + TCA)
│   ├── Search/                          # GitHub User Search Feature
│   │   ├── SearchState.swift            # query, users, isLoading, errorMessage (Hashable)
│   │   ├── SearchAction.swift           # @CasePathable: view, internal, response, delegate
│   │   ├── SearchReducer.swift          # Effect.run with ContinuousClock debounce & searchUsersUseCase
│   │   ├── SearchView.swift             # SwiftUI View: .searchable, List, Refreshable
│   │   └── Components/
│   │       ├── UserRowView.swift        # User row item (AsyncImage, avatar, username)
│   │       └── SearchEmptyView.swift    # Empty, initial, and error state view
│   │
│   └── Detail/                          # GitHub User Detail Feature
│       ├── DetailState.swift            # user: User (Hashable)
│       ├── DetailAction.swift           # @CasePathable: openProfileButtonTapped
│       ├── DetailReducer.swift          # Handles opening Safari via @Dependency(\.openURL)
│       └── DetailView.swift             # Profile view with avatar, user ID, profile link
│
├── Domain/                              # Domain Layer (Pure Business Logic)
│   ├── Entities/
│   │   └── User.swift                   # Pure Domain Entity
│   ├── Interfaces/
│   │   └── Repositories/
│   │       └── UserRepositoryProtocol.swift # Repository contract protocol
│   └── UseCases/
│       └── SearchUsersUseCase.swift     # Pure use-case abstraction over repository search
│
├── Data/                                # Data Layer (Repositories & Data Sources)
│   ├── DTOs/
│   │   ├── UserDTO.swift                # Decodable GitHub API Model with toDomain() mapper
│   │   └── ItemSearchResponseDTO.swift  # API search container
│   └── Repositories/
│       └── UserRepository.swift         # Concrete implementation of UserRepositoryProtocol
│
├── Infrastructure/                      # Infrastructure Layer (Network & External Services)
│   └── Network/
│       ├── BaseAPI.swift                # Core network engine (async/await, error body parsing)
│       ├── TargetType.swift             # HTTPMethod, RequestType, HTTPTask (Encodable & params)
│       ├── APIRouter.swift              # Endpoint definitions conforming to TargetType
│       ├── APIError/
│       │   ├── APIError.swift           # Rich localized error descriptions
│       │   └── AFError+Extension.swift  # Network connectivity & timeout helpers
│       ├── AFNetworking/
│       │   ├── AFNetworking.swift       # Session wrapper & reachability monitoring
│       │   └── RequestInterceptor.swift # Thread-safe actor-based token refresher (no deadlock)
│       └── Logger/
│           └── AlamofireLogger.swift    # Request & response logger
│
├── AppConfig/
│   ├── Configs.swift                    # Thread-safe Singleton configuration (Sendable)
│   └── AppEnvironment.swift             # App environment enum (Sendable)
│
├── Extensions/
│   ├── UIKit/                           # UIApplication, UIColor extensions
│   └── Foundation/                      # String extensions
│
└── Resources/
    ├── Assets iOS.xcassets              # Image and icon assets
    ├── Colors iOS.xcassets              # Color palette assets
    ├── Localizables/                    # Multilingual strings (en, fr)
    ├── LaunchScreen.storyboard          # Static system launch screen shown before SwiftUI
    ├── Info.plist                       # Bundle configuration
    └── Swiftgen/                        # Auto-generated code by SwiftGen
```

---

## 📋 Prerequisites

- **macOS**: Sonoma 14.0 or higher
- **Xcode**: 16.0+
- **iOS Deployment Target**: iOS 16.0+
- **Homebrew**: Installed on your Mac
- **Mint**: Swift command-line tool manager

---

## 🚀 Getting Started

Open your Terminal in the project root directory and execute:

### 1. Install Tooling & Dependencies
```bash
# Install Mint and libxml2 via Homebrew
make brew-install

# Install CLI tools (XcodeGen, SwiftGen, SwiftLint) and Bundler gems
make install
```

### 2. Generate Xcode Project & Open
```bash
# Generate my-app.xcodeproj using XcodeGen
make generate

# Generate asset/string constants using SwiftGen (if assets were updated)
make swiftgen

# Open the project in Xcode
make open
```

Or run everything in a single command:
```bash
make all
```

---

## ⚡ Useful Makefile Commands

| Command | Description |
|---|---|
| `make all` | Installs tools, generates the Xcode project, runs SwiftGen, and opens Xcode |
| `make brew-install` | Installs `mint` and `libxml2` via Homebrew |
| `make install` | Installs Mint packages (`mint bootstrap`) and Ruby gems (`bundle install`) |
| `make generate` | Regenerates `my-app.xcodeproj` from `project.yml` |
| `make swiftgen` | Scans assets & strings to generate type-safe Swift code |
| `make lint` | Runs SwiftLint against sources and tests |
| `make test` | Runs all Unit Tests via Swift Testing on the iOS Simulator |
| `make open` | Opens the project in Xcode |

---

## ⚠️ Developer Notes & Troubleshooting

### 1. Swift Macros Trust Dialog
The project relies on official Swift Macros from Point-Free (`@Reducer`, `@ObservableState`, `@CasePathable`, `@DependencyClient`). When opening the project for the first time in Xcode, a security prompt will appear:
> *"Macros with malicious code can harm your Mac... Be sure you trust the source of macros before you enable them."*

👉 Click **"Trust & Enable"** (or select the macros and click **Enable**). This is a standard one-time Xcode security confirmation for third-party Swift macros.

When compiling via command line (`xcodebuild`), append `-skipMacroValidation` to avoid being blocked by this prompt.

### 2. Dependency Management in `project.yml`
Do **not** add packages manually through the Xcode UI since `my-app.xcodeproj` is generated by XcodeGen and is gitignored. To add a new dependency:
1. Add the Git repository URL and version requirement under `packages:` in [project.yml](project.yml).
2. Add the product under `dependencies:` for the `my-app` target.
3. Run `make generate` to regenerate the project.

The package versions in `project.yml` are pinned exactly so local and CI builds resolve the same dependency graph.

### 3. Tests and CI

`make test` collects code coverage. The default simulator can be overridden when needed:

```bash
make test TEST_DESTINATION='platform=iOS Simulator,OS=latest,name=iPhone 16 Pro'
```

Pull requests and pushes to `main` or `master` run project generation, SwiftGen, SwiftLint, and tests through `.github/workflows/ci.yml`.

### 4. Release configuration

Fastlane reads credentials and signing configuration from environment variables. Copy `fastlane/.env.example` to the ignored `fastlane/.env` for local use, or configure equivalent encrypted CI secrets. Never commit `.p8`, `.p12`, webhook credentials, or populated environment files.
