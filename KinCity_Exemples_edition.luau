-- À lancer APRÈS l'installateur, dans la Command Bar en mode édition.
-- Choisissez UNE opération à exécuter; ne collez pas toute la liste.

-- Régénérer uniquement les pièces de la bibliothèque (incluant étages et toit) :
-- require(game.ServerScriptService.KinCityRuntime.WorldEditor).regenerateInterior("library")

-- Régénérer uniquement la façade du palais de justice :
-- require(game.ServerScriptService.KinCityRuntime.WorldEditor).regenerateFacade("ethikos.justice_palace")

-- Reconstruire l'ensemble du monde à partir des catalogues :
-- require(game.ServerScriptService.KinCityRuntime.WorldEditor).regenerateAll()
