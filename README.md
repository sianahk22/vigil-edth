# VIGIL : détection et suivi de petits aéronefs

Projet de l'**équipe VIGIL (n°39)** au **European Defense Tech Hackathon (EDTH) Paris**, du 20 au 22 novembre 2026.

## Défi 06 : Small Aircraft Detection and Tracking

- **Objectif** : améliorer la baseline **RF-DETR** pour détecter et suivre de petits aéronefs (drones) dans des vidéos.
- **Dataset** (fourni par les organisateurs, non versionné ici) : 1 609 images (859 train / 422 val / 328 test), 8 séquences de tracking, 3 classes, images négatives, 200 images de calibration.
- **Sorties attendues** : détections au format **COCO JSON**, tracking au format **MOT**.
- **Métriques** : mAP, AP small, MOTA, IDF1, continuité des pistes.
- **Cible matérielle** : puce edge **Axelera** (1 Go, INT8, export ONNX).

## Structure du dépôt

```
src/        code du modèle, de l'entraînement et du tracking
scripts/    scripts utilitaires (évaluation, export, démo)
results/    métriques et résultats légers (pas de poids de modèle)
os/         outils pour le Raspberry Pi (flash de la carte SD)
data/       dataset des organisateurs (ignoré par Git, à placer en local)
```

## Mise en place

1. Cloner le dépôt.
2. Placer le dataset fourni par les organisateurs dans `data/`.
3. Suivre le `starter-kit/README.md` du dataset pour installer l'environnement.

> Ne jamais commiter de données, de poids de modèle ni de fichier `.env` (voir `.gitignore`).

## Rendu

- Deck PDF/PPTX nommé `39_...`, à rendre avant dimanche midi
- Vidéo de démonstration
- Pitch de 3 minutes
