#!/user/bin/env boot

(set-env! :dependencies '[[alandipert/hyperturbo "1.0.0"]
						  [postgresql "42.1.4.jdbc42"]])
(require '[alandipert.hyperturbo.lunar-lander :refer [run]])

(defn -main [& args]
    (run))
