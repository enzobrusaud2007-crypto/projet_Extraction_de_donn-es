## Travail collaboratif

### L'équipe (Groupe 5)

| Membre | Rôle |
|---|---|
| Enzo Brusaud | Chef de projet : création de l'équipe Teams, du dépôt GitHub et du projet Jira ; V1, V2, V3 ; rédaction du README |
| Wael Saffiedine | Variantes ; relecture du code des versions de base |
| Ilias Bariol-Alaoui | Tests des scripts sur la sortie réelle de wttr.in ; V3 corrigée (option d'historique, correctifs) et variante 3 (gestion des erreurs et des logs) sur la branche `feature/variante3` ; rédaction de la partie travail collaboratif / gestion de projet |
| Matteo Lubat | *(à compléter)* |
| Mohamed Amine Khadraoui | *(à compléter)* |

Enseignants ajoutés à l'équipe Teams : M. Bilal Chebaro et M. Cédric Teyssié.

### Outils utilisés

- **Microsoft Teams** : équipe « toulouse-12-26-27 Groupe 5 Projet Configuration d'un poste de travail », avec deux canaux :
  - *Discussion avec les enseignants pour le projet* : échanges avec les enseignants ;
  - *Organisation et avancement du projet* : coordination de l'équipe, partage du code de chaque version, relectures et répartition des tâches.

  L'onglet *Partagé* regroupe le sujet, le dossier attendu et la procédure d'intégration Jira Cloud.
- **Git / GitHub** : dépôt `projet_Extraction_de_donn-es`, créé le 28/10 ; tous les membres y sont ajoutés pour suivre l'avancement à chaque commit. Conventions :
  - une branche par version (`feature/v2`, `feature/v3`, `feature/variante3`…), fusionnée ensuite dans `main` ;
  - un commit par fonctionnalité ajoutée ou à chaque interruption de travail ;
  - les tags `v1`, `v2` et `v3` pour les versions de base, et `Variante1`, `Variante2` et `Variante3` pour les variantes. Cette convention a été décidée le 04/11 pour éviter les erreurs de tags.
- **Jira Cloud** : chaque membre crée son compte, puis le chef de projet invite les membres dans le projet Jira.

### Relecture croisée

Les versions publiées dans Teams sont relues par un autre membre de l'équipe :

- **V1 / V2** : Wael a repéré une parenthèse en trop dans le format de l'heure (`date "+%H:%M)"`), qu'Enzo a corrigée le 04/11.
- **V3** : Wael a signalé que `rm -f` ne fait pas partie des commandes autorisées et a posé une question sur le nom du fichier d'historique.
- **Tests sur données réelles** : Ilias a exécuté la V1/V2 sur la sortie réelle de wttr.in le 05/11. Les colonnes du tableau de prévisions sont séparées par le caractère `│` (trait de tableau) et non par `|`. Le `cut -d"|"` ne découpait donc rien, et le script renvoyait la température du matin au lieu de celle de midi. Ilias a proposé un correctif, testé sur Toulouse et sur Yakutsk pour les températures négatives. Il a aussi corrigé dans la V3 le `$` manquant devant `fichier_historique` (les relevés partaient dans un fichier nommé « fichier_historique ») et ajouté l'option d'archivage demandée par le sujet.

## Gestion de projet

### Approche

Nous avons suivi une démarche **incrémentale**, en suivant le découpage du sujet :

1. **Une version à la fois** : V1 → V2 → V3 → variantes. Chaque version est fonctionnelle avant de passer à la suivante.
2. **Une version = un cycle court** : développement, publication du code dans Teams, relecture par un autre membre, correction, puis commit et tag Git.
3. **Répartition par blocs** : les versions de base sont confiées à un membre et les variantes à un autre, pour avancer en parallèle. Les autres membres se chargent des tests et de la rédaction du dossier.
4. **Suivi** : Teams sert de point de coordination quotidien, GitHub d'historique technique (commits, tags), et Jira de suivi des tâches.

### Chronologie

| Date | Étape |
|---|---|
| 15/10 | Création de l'équipe Teams par le chef de projet (canaux, ajout du bot Jira) |
| 19/10 | Invitation des membres dans l'équipe Teams (comptes MIAGE) |
| 20/10 | Message de lancement : objectif (dossier complet), échéance du 06/11, Git comme espace de travail ; lecture du sujet et recueil des disponibilités pour une réunion de lancement |
| 28/10 | Création du dépôt GitHub et partage du lien |
| 02/11 | Création des comptes Jira, invitation sur le projet Jira et sur le dépôt GitHub |
| 03/11 | V1 terminée ; tentative d'intégration Jira–Teams, bloquée par les droits d'administration, et mail à M. Chebaro |
| 04/11 | M. Chebaro transmet la demande à M. Teyssié (administrateur) ; V1, V2 et explication de cron partagées et relues ; répartition V3 / variantes / rapport ; convention de tags |
| 05/11 | Tests sur la sortie réelle de wttr.in et correctif de l'extraction de la prévision ; branche `feature/variante3` : V3 corrigée puis variante 3 ; variantes 1 et 2 en cours |
| 06/11 | Rendu du dossier |

### Difficultés rencontrées et solutions

| Difficulté | Solution |
|---|---|
| L'intégration Jira–Teams demande des droits que le chef de projet n'a pas | Demande à M. Chebaro, transmise à M. Teyssié (administrateur) ; en attendant, le suivi se fait dans le canal Teams |
| Blocage du campus : certains membres ne peuvent pas venir à la fac | Coordination entièrement à distance via Teams, code partagé dans les publications et sur GitHub |
| Commandes limitées (`grep`, `head`, `tail`, `tr`, `cut`, `rev`, `xargs`, `echo`) | Suppression de `rm -f`, inutile puisque `>` écrase le fichier brut à chaque exécution ; usage de `date` à confirmer auprès des enseignants |
| Format du tableau wttr.in (séparateur `│`) | Extraction par motif `grep -o -E` sur les températures au lieu d'un découpage par colonnes |
