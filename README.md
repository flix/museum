# museum

A small Flix example that combines separate packages into a museum visit. It
demonstrates direct dependencies, a shared transitive dependency, and a Maven
dependency.

The five packages live in separate repositories:

| Package | Role |
| --- | --- |
| `flix/museum` | Coordinates a visit through `Museum.visitMuseum()`. |
| `flix/museum-entrance` | Buys a ticket, calling `Clerk.work()` first. |
| `flix/museum-giftshop` | Buys a gift, calling `Clerk.work()` first. |
| `flix/museum-clerk` | Welcomes visitors through `Clerk.welcomeVisitor()` and provides the shared `Clerk.work()` function. |
| `flix/museum-restaurant` | Buys a meal and declares a Maven dependency on Apache Commons Lang. |

For museum `2.1.1`, the dependency graph selects these package versions. The
clerk edges show each consumer's minimum requirement:

```mermaid
flowchart TD
    M["museum 2.1.1"] --> E["museum-entrance 2.0.1"]
    M --> G["museum-giftshop 2.0.1"]
    M --> R["museum-restaurant 2.0.1"]
    M -->|requires 2.1.1| C["museum-clerk 2.1.1"]
    E -->|requires 2.1.1| C
    G -->|requires 2.1.1| C
    R --> J["org.apache.commons:commons-lang3 3.12.0"]
```

Dependency versions are minimum requirements. Within one major version, Flix
selects the greatest required version of each package. Museum, entrance, and
gift shop all require clerk `2.1.1`, so every consumer resolves to that version.
The `Clerk.welcomeVisitor()` function that museum calls was introduced in clerk
`2.1.0`.

Earlier releases exercised the selection rule with divergent requirements:
entrance `2.0.0` and gift shop `2.0.0` each required clerk `2.0.0` while museum
`2.1.0` required clerk `2.1.0`, and all three consumers resolved to `2.1.0`.

Each consumer declares its own dependency mounts. Museum imports `Clerk` with
`use clerk::Clerk` through its direct `clerk` dependency. Entrance and gift shop
each declare their own `clerk` mount. Museum also mounts `entrance`, `giftshop`,
and `restaurant`; its restaurant dependency has `security = "unrestricted"`.

The restaurant declares Apache Commons Lang as a Maven dependency, although its
current source does not use that library.

Calling [`Museum.visitMuseum()`](src/Museum.flix) welcomes the visitor, buys a
ticket, buys a meal, and then buys a gift. A visit produces:

```text
Welcome to the museum!
Clerking...
Entrance.buyTicket() was called.
Museum.Restaurant.buyMeal() was called.
Clerking...
Giftshop.buyGift() was called.
```

Each package has a `src/` directory for its module, a `test/` directory, and a
`flix.toml` manifest. All five manifests specify Flix `0.76.2`. The
`test/TestMain.flix` files are currently empty, and there is no `main` function.
Run a visit from this checkout by selecting the entry point explicitly:

```shell
java -jar flix.jar run --entrypoint Museum.visitMuseum
```

The dependencies in [`flix.toml`](flix.toml) reference versioned GitHub packages.
Checking out the repositories next to each other does not connect their local
sources automatically: changing a sibling checkout alone does not change the
dependency used by this package.

The compiler maintains [`packages.lock`](packages.lock), recording SHA-256
digests of dependency manifests it reads and package archives it downloads.
Version selection follows the manifest requirements; the lockfile verifies
artifact contents. Because every consumer now requires the same clerk version,
the lockfile holds a single clerk entry at `2.1.1` with both digests. When
requirements diverge it can also record a manifest read during resolution whose
archive was not the one selected.
