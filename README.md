## Automatisation avec cron 

1. Ouvrir la table des tâches : crontab -e
2. Ajouter la ligne suivante (exécution toutes les heures) en remplaçant le chemin : 

0 * * * * cd /chemin/vers/le/depot && bash Extracteur_Meteo.sh

Les 5 champs sont : minute, heure, jour du mois, mois, jour de la semaine. 
Une étoile '*' signifie 'à chaque'. Par exemple, '*/30 * * * *' = toutes les 30 minutes.
Le 'cd' est nécessaire parce que cron n'éxecute pas le script dans le dossier du projet.

3. Enregistrer et quitter l'éditeur
4. Vérifier avec 'crontab -l', puis consulter 'meteo.txt' quelques minutes plus tard.
5. Pour arrêter la tâche : taper 'crontab -e' et supprimer la ligne.

Sous Windows (WSL), cron ne démarre pas automatiquement, il faut taper 'sudo service cron strat'.

