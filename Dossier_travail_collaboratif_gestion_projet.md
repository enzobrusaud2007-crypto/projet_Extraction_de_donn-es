## Dépôt distant

https://github.com/enzobrusaud2007-crypto/projet_Extraction_de_donn-es

## Travail collaboratif

| Membre | Rôle |
|---|---|
| Enzo Brusaud | Chef de projet (Teams, GitHub, Jira) ; V1, V2, V3 ; README |
| Wael Saffiedine | Variantes ; relecture du code |
| Ilias Bariol-Alaoui | Tests sur la sortie réelle de wttr.in ; V3 corrigée et variante 3 ; dossier (travail collaboratif, gestion de projet) |
| Matteo Lubat | Membre de l'équipe |
| Mohamed Amine Khadraoui | Membre de l'équipe |

- **Teams** : un canal pour l'organisation de l'équipe (partage du code, relectures, répartition) et un canal pour les échanges avec les enseignants.
- **GitHub** : une branche par version (`feature/v2`, `feature/v3`, `feature/variante3`), des commits réguliers, des tags `v1`, `v2`, `v3`, puis `Variante1`, `Variante2` et `Variante3`.
- **Jira** : suivi des tâches. L'intégration Jira–Teams demande des droits d'administration, et la demande a été transmise aux enseignants.
- **Relecture croisée** : chaque version publiée sur Teams est relue par un autre membre. Exemples : la parenthèse en trop dans l'heure, `rm` non autorisé, l'extraction de la prévision.

## Gestion de projet

Démarche **incrémentale** qui suit le découpage du sujet. On traite une version à la fois (V1 → V2 → V3 → variantes). Pour chaque version, on suit le même cycle : développement, publication sur Teams, relecture, correction, puis commit et tag. Les versions de base et les variantes ont avancé en parallèle, et la coordination s'est faite à distance via Teams pendant le blocage du campus.

Étapes clés :
- **20/10** : lancement du projet.
- **28/10** : création du dépôt.
- **03/11 et 04/11** : V1, V2 et V3.
- **05/11** : tests, corrections et variante 3.
- **06/11** : rendu.

## Solution implémentée : V3 corrigée et variante 3

Utilisation : `./Extracteur_Meteo.sh [-h] [ville]`. Sans ville, le script prend Toulouse. L'option `-h` archive le relevé dans le fichier du jour.

- **Prévision du lendemain** : les colonnes de wttr.in sont séparées par `│` et non par `|`, donc `cut -d"|"` ne découpait rien et renvoyait la température du matin. On extrait maintenant les 4 températures de la ligne de demain avec `grep -o -E "[-+]?[0-9]+(\([-+]?[0-9]+\))? °C"`, puis on garde celle de midi avec `head -2 | tail -1`.
- **V3 (historique)** : avec `-h`, la ligne est ajoutée à `meteo_$(date "+%Y%m%d").txt`, ce qui donne un fichier par jour. Le `$` manquait devant `fichier_historique`, et `rm -f` a été retiré : il n'est pas autorisé, et `>` écrase déjà le fichier brut.
- **Variante 3 (erreurs et logs)** : si wttr.in est injoignable, si la ville est inconnue (`curl -f`) ou si la réponse n'a pas de température, un message horodaté `[AAAA-MM-JJ HH:MM:SS] ERREUR` est ajouté à `meteo_error.log`, et le script s'arrête avec le code 1.

Tests du 05/11 :
- `Toulouse` donne `7°C - 14°C`.
- `Yakutsk` donne `-15°C - -18°C` (températures négatives).
- `-h "Saint Petersburg"` crée bien le fichier du jour.
- `Zzqxwvlk` écrit une erreur horodatée dans `meteo_error.log`.
