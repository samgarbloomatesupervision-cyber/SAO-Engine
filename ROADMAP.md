# FEUILLE DE ROUTE COMPLÈTE — MMORPG SAO (Roblox + Cardinal)
(structure professionnelle, modulaire, maintenable, scalable)

## 🟩 PHASE 0 — Fondations techniques (Cardinal Core)
Objectif : construire un framework solide, modulaire, facile à maintenir.

Modules Cardinal à créer :
*   **Cardinal.Events** (RemoteEvents centralisés)
*   **Cardinal.Modules** (Combat, Weapons, Skills, AI, Loot, UI, Zones)
*   **Cardinal.Data** (DataStore, profils, sauvegarde)
*   **Cardinal.UI** (HUD, menus, notifications, responsive)
*   **Cardinal.Input** (souris, clavier, mobile, manette)
*   **Cardinal.Utils** (math, tween, raycast, pooling)

Résultat : Une base propre, documentée, sans dépendances croisées, facile à maintenir.

## 🟥 PHASE 1 — Système d’armes (10 armes uniques)
Objectif : créer 10 armes réparties en rôles : 2 Tank, 6 DPS, 2 Heal
Pour chaque arme : Modèle 3D optimisé, Texture HD stylée SAO, Icône UI, Combo 3 coups unique, Skills dédiés, Scaling stats, Effets visuels, SFX.

## 🟧 PHASE 2 — Gameplay de combat (nerveux, fluide, SAO)
Systèmes : 3 coups souris, Dash + iFrames, Hitbox précises, Hitstop, CameraShake léger, Targeting optionnel, Gestion stamina / mana, Cooldowns skills.

## 🟨 PHASE 3 — Interface & UI (responsive + raccourcis)
HUD : Barre HP, Stamina/Mana, XP, Slot potion, Slot skills, Notifications, Level Up.
Menus : Inventaire, Profil, Skills, Quêtes, Carte, Paramètres.
Responsive : UIScale dynamique, UIAspectRatioConstraint, Safe zones mobile.

## 🟫 PHASE 4 — Interactions Roblox natives (E pour tout)
ProximityPrompt : Ramasser loot, Parler PNJ, Ouvrir coffre, Activer mécanismes.
ContextActionService : Raccourcis skills, Raccourcis potions, Dash.

## 🟦 PHASE 5 — IA (loups + mobs + boss)
Loups : Aggro dynamique, Attaques contextuelles, Esquives, Coordination, Fuite si low HP.
Boss 1er étage : 4 barres de vie, 3 phases, Patterns spéciaux, Attaques télégraphiées, Attaques ultimes, Anti‑cheese, Musique dynamique.

## 🟩 PHASE 6 — Loot + Ramassage auto + Craft + Upgrade
Loot : Col, XP, Composants, Loot rare.
Ramassage auto : Aimantation, Animation, Notification, Filtrage.
Craft : Recettes, Matériaux, PNJ artisan.
Upgrade : Forgeron, Amélioration stats, Évolution d’arme, Effets visuels.

## 🟥 PHASE 7 — Zone complète du 1er étage
Ville : Forge, Marché, PNJ quêtes, Auberge, Décor SAO.
Extérieur : Forêt, Prairie, Ruines, Spots de mobs.
Quêtes : Principales, Secondaires, Quotidiennes.

## 🟦 PHASE 8 — Optimisation + Polishing final
Optimisations : Pooling VFX, Pooling UI, Pathfinding optimisé, Scripts nettoyés, Réduction des events.
Polishing : Transitions, Sons, Effets, Feedback, Animations.
