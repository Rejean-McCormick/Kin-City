# Kin City — État de la construction v26

**Développé hors Roblox Studio** : la coupure technique entre extérieur (`city`) et huit grands intérieurs est maintenant opérationnelle dans les générateurs et neuf scripts Command Bar autonomes.

La ville extérieure génère façades, quartiers, transports, habitants et lieux publics **sans grands intérieurs**. Chaque Place institutionnelle génère **son propre bâtiment intérieur détaillé uniquement**, avec porte de sortie et activités locales. Les portes de transfert fonctionnent par `TeleportAsync` uniquement après saisie et publication de neuf vrais PlaceIds; l'aperçu `SPLIT_PREVIEW` ne simule pas un voyage entre Places. `LOCAL_UNIVERSE` reste une option d'essai tout-en-un séparée.

**Conservés** : styles sarcelle et cristal, 57 bâtiments secondaires finis v25, huit institutions à plusieurs niveaux, vitrines, expos, coopérations, PNJ et transports de la ville, bibliothèques OBJ/PBR facultatives. Pas de kOA actif.

**À qualifier réellement** : création/publication des Places, vérification des passages aller/retour depuis le client Roblox, présence des atterrissages et éventuels obstacles, performance mobile et expérience multijoueur. Aucun test Roblox Studio n'a été exécuté ici.
