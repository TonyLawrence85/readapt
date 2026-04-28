// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
import PlyrController from "./plyr_controller"
application.register("plyr", PlyrController)
import KaraokeController from "./karaoke_controller"
application.register("karaoke", KaraokeController)
