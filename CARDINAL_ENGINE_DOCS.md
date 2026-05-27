# MOTEUR CARDINAL - DOCUMENTATION OFFICIELLE (v4)
*L'architecture d'un MMORPG AAA sur Roblox*

Le Moteur Cardinal n'est pas un ensemble de scripts, c'est un **système d'exploitation** pour votre jeu. Il est conçu pour être 100% modulaire, Data-Driven, et auto-réparant.

---

## 1. STRUCTURE DU NOYAU (ReplicatedStorage.Cardinal)

### ⚙️ Core (`Cardinal.Core`)
*   **Init.lua** : Le point d'entrée. Démarre les données, utilitaires, services, le Watchdog, puis les systèmes métier, dans un ordre strict. Utilise le *Safe Load* pour ne jamais crasher.
*   **Config.lua** : Paramètres globaux (Régénération, Dégâts, etc.).

### 📊 Data (`Cardinal.Data`)
*C'est ici que le contenu du jeu est défini. Vous ne devriez jamais avoir besoin de modifier les `Systems` pour ajouter du contenu, uniquement ces fichiers de données.*
*   **WeaponData** : Stats, Scaling, Animations, SFX, VFX de chaque arme.
*   **ComboProfiles** : Les fenêtres de temps (`TimeWindow`) et les coûts en stamina pour les enchaînements.
*   **MobData** : Stats des monstres, Aggro, IA de fuite, Patterns d'attaque.
*   **QuestData** : Objectifs et récompenses des quêtes.
*   **ZoneData** : Définition des zones (Village, Forêt, Ruines) et des monstres qui y spawnent.
*   **CraftingData** : Recettes de forge et coûts d'upgrades.
*   **InteractionData** : Tables de loot des coffres et inventaires des marchands.

### 🛡️ Watchdog (`Cardinal.Watchdog`)
*Le "Petit Frère" de Cardinal. Il surveille l'intégrité du jeu en permanence.*
*   Vérifie que l'UI est toujours visible sur le client (`ClientWatch`).
*   Bloque les scripts isolés dans le Workspace (`ServerWatch`).
*   Répare automatiquement les modules défectueux (`AutoFix`).

### 🧰 Utils & Services
*   **RateLimiter** : Anti-spam pour les attaques et interactions (Sécurité).
*   **Diagnostics** : Scan le jeu au démarrage et affiche les erreurs (F9).
*   **DataStoreWrapper** : Encapsule les appels de sauvegarde avec des *Retries* (Sécurité).

---

## 2. SYSTÈMES MÉTIER (`Cardinal.Systems`)

*   **Combat** : Le moteur nerveux. Gère les combos, les iFrames, le Dash, les dégâts via *Spatial Query* (Hitboxes parfaites), et le Hitstop.
*   **AI** : Le cerveau multi-threadé (Parallel Luau) gérant des centaines de monstres sans lag. Intègre les états Aggro, Flee, Patrol.
*   **Loot** : Le moteur économique. Gère l'aimantation visuelle des objets au sol et le ramassage automatique.
*   **UI** : Orchestrateur de l'interface. Découplé du jeu via `Bindings.lua`. Gère le HUD (Stamina/Mana), l'Action Bar et le Menu Tab holographique.
*   **Interactions** : Gestionnaire universel de la touche 'E'. Gère les coffres, les marchands et les PNJ de manière sécurisée côté serveur.
*   **Persistence** : Sauvegarde automatique (AutoSave) et chargement des profils joueurs.
*   **AssetPipeline** : Prototype d'intégration pour les assets générés par IA.

---

## 3. COMMENT ÉTENDRE LE JEU ? (Pipeline d'Ajout)

### Ajouter une Nouvelle Arme
1.  **Modèle 3D** : Placez votre MeshPart dans `Cardinal.Assets.Weapons.[NomArme]`. Nommez-le `Handle`.
2.  **Configuration** : Ouvrez `Cardinal.Data.WeaponData` et ajoutez les statistiques (Dégâts, Rôle, Animations).
3.  *C'est tout. Le jeu la chargera, créera les VFX de slash, et l'ajoutera aux menus.*

### Ajouter un Nouveau Monstre
1.  **Modèle 3D** : Placez le modèle dans `ServerStorage.Mobs`.
2.  **Configuration** : Ouvrez `Cardinal.Data.MobData` et définissez ses HP, ses attaques et son comportement d'Aggro.
3.  **Apparition** : Ajoutez-le à la liste `Mobs` d'une zone dans `Cardinal.Data.ZoneData`.

### Ajouter une Quête
1.  Ouvrez `Cardinal.Data.QuestData` et définissez l'objectif (ex: Tuer 5 Loups).
2.  Le moteur `Cardinal.Quests` s'occupera du suivi, de la barre de progression dans l'UI, et de la distribution des récompenses (XP/Col).

---

## 4. VISION "IA STUDIO"
Le jeu est structuré pour s'interfacer avec des générateurs d'Intelligence Artificielle. Le manifeste (`ASSET_PIPELINE_MANIFEST.md`) décrit comment des outils externes (Blender, API Node.js, Meshy, Udio) peuvent générer du contenu brut qui sera automatiquement intégré dans le Moteur Cardinal via le système `AssetPipeline`.

*Bonne conquête d'Aincrad.*
