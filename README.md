# my-app 🚀

A modern iOS application built with **SwiftUI**, **The Composable Architecture (TCA)**, and **Swift Concurrency**. Dependencies are fully managed via **Swift Package Manager (SPM)**, and project generation is automated using **XcodeGen**.

---

## 🛠️ Tech Stack & Architecture

- **UI Framework**: SwiftUI (iOS 16.0+)
- **Architecture & State Management**: [The Composable Architecture (TCA)](https://github.com/pointfreeco/swift-composable-architecture) v1.26+ with a central Root Reducer coordinating navigation and child domains.
- **Dependency Management**: Swift Package Manager (SPM) integrated directly inside `project.yml`.
- **Concurrency**: 100% modern Swift Concurrency (`async/await`, `Task`, `Sendable`, `ContinuousClock`).
- **Project Generator**: [XcodeGen](https://github.com/yonaskolb/XcodeGen) — `.xcodeproj` is never checked into Git.
- **Code Generation**: [SwiftGen](https://github.com/SwiftGen/SwiftGen) with a custom Stencil template compatible with Swift 6 Concurrency.
- **CLI Tool Management**: [Mint](https://github.com/yonaskolb/mint).
- **CI/CD & Automation**: [Fastlane](https://fastlane.tools).
- **Networking**: [Alamofire](https://github.com/Alamofire/Alamofire) 5.12+ (with async/await support).
- **UI Libraries**: [Lottie-SPM](https://github.com/airbnb/lottie-spm), [SDWebImage](https://github.com/SDWebImage/SDWebImage).

---

## 📁 Project Structure

The project follows the **File Separation Pattern**. Each feature is broken down into granular, focused files (~25 to 80 lines per file) to ensure readability, separation of concerns, and maintainability:

```
Sources/
├── App Delegate/
│   ├── MyApp.swift                      # SwiftUI @main App entry point, initializes root Store
│   ├── AppDelegate.swift                # UIApplicationDelegate (Lifecycle, APNs, Reachability)
│   └── LaunchScreen.storyboard
│
├── Features/                            # Feature modules adhering to TCA pattern
│   ├── Root/                            # Global Root Reducer coordinating NavigationStack & routes
│   │   ├── RootState.swift              # StackState<RootPath.State>, RootPath enum
│   │   ├── RootAction.swift             # @CasePathable: search, path (StackAction)
│   │   ├── RootReducer.swift            # Orchestrates child delegate actions & push/pop navigation
│   │   └── RootView.swift               # Global NavigationStack container
│   │
│   ├── Search/                          # GitHub User Search Feature
│   │   ├── SearchState.swift            # query, users, isLoading, errorMessage
│   │   ├── SearchAction.swift           # @CasePathable: view, internal, response, delegate
│   │   ├── SearchReducer.swift          # Effect.run with ContinuousClock debounce
│   │   ├── SearchView.swift             # SwiftUI View: .searchable, List, Refreshable
│   │   └── Components/
│   │       ├── UserRowView.swift        # User row item (AsyncImage, avatar, username)
│   │       └── SearchEmptyView.swift    # Empty, initial, and error state view
│   │
│   └── Detail/                          # GitHub User Detail Feature
│       ├── DetailState.swift            # user: SearchModel
│       ├── DetailAction.swift           # @CasePathable: openProfileButtonTapped
│       ├── DetailReducer.swift          # Handles opening Safari via @Dependency(\.openURL)
│       └── DetailView.swift             # Profile view with avatar, user ID, profile link
│
├── NetworkLayer/
│   ├── Client/
│   │   └── SearchClient.swift           # TCA @DependencyClient (async/await, live & mock implementations)
│   ├── Model/
│   │   └── SearchModel.swift            # SearchModel & ItemSearchResponse (Sendable)
│   └── APIRouter.swift                  # API Endpoint definitions
│
├── Base/
│   └── BaseNetwork/
│       ├── BaseAPI.swift                # Core network layer with fetchDataAsync (async/await)
│       ├── TargetType.swift             # TargetType, HTTPMethod, Task (Sendable)
│       └── AFNetworking/                # AFNetworking Session & RequestInterceptor
│
├── AppConfig/
│   ├── Configs.swift                    # Thread-safe Singleton configuration (Sendable)
│   └── Enviroment.swift                 # App environment enum (Sendable)
│
└── Supporting Files/
    ├── Assets.xcassets                  # Image and color assets
    ├── Info.plist                       # Bundle configuration
    └── Swiftgen/                        # Auto-generated code by SwiftGen
```

---

## 📋 Prerequisites

- **macOS**: Sonoma 14.0 or higher
- **Xcode**: 15.0+ (Xcode 16.0+ recommended)
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
