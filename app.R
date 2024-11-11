source(file.path("R", "build.R"))

ui <- shiny::fluidPage(
    shiny::titlePanel("Roguelike Sprite Builder"),
    htmltools::p(
        "A work in progress using",
        htmltools::a(
            href = "https://kenney.nl/assets/roguelike-characters",
            "the Roguelike Characters pack"
        ),
        "(CC0) created and distributed by",
        htmltools::a(href = "https://www.kenney.nl", "Kenney.")
    ),
    shiny::actionButton(
        inputId = "btn_reroll",
        label = "Reroll",
        icon = shiny::icon("dice")
    ),
    shiny::plotOutput("sprite")
)

server <- function(input, output) {

    output$sprite <- shiny::renderPlot({
        list.files(file.path("www", "img"), ".png", full.names = TRUE) |>
            draw_random_sprite()
    })

    shiny::observeEvent(input$"btn_reroll", {
        output$sprite <- shiny::renderPlot({
            list.files(file.path("www", "img"), ".png", full.names = TRUE) |>
                draw_random_sprite()
        })
    })



}

shiny::shinyApp(ui, server)
