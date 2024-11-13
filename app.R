source(file.path("R", "build.R"))

ui <- shiny::fluidPage(
    shiny::titlePanel("Roguelike Sprite Builder"),
    htmltools::p(
        htmltools::a(
            href = "https://github.com/matt-dray/roguelike-sprite-builder",
            shiny::icon("github")
        ),
        "A work in progress by",
        htmltools::a(
            href = "https://www.matt-dray.com/",
            "matt-dray"
        ),
        "using",
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
    shiny::downloadButton(
        outputId = "sprite_download",
        icon = shiny::icon("floppy-disk")
    ),
    shiny::plotOutput("sprite")
)

server <- function(input, output) {

    rv <- shiny::reactiveValues()  # store parts here, but start empty

    create_sprite <- reactive({
        rv$parts <- pick_parts()
        draw_sprite(rv$parts)
    }) |>
        shiny::bindEvent(
            input$btn_reroll,  # fire on button press
            ignoreNULL = FALSE  # also fire if input is NULL (i.e. on startup)
        )

    output$sprite <- shiny::renderPlot(create_sprite())

    output$sprite_download <- shiny::downloadHandler(
        filename = "sprite.png",
        content = function(file) {
            png(file)
            draw_sprite(rv$parts)
            dev.off()
        })

}

shiny::shinyApp(ui, server)
