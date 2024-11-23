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
        outputId = "dl_sprite_16",
        label = "PNG 16px",
        icon = shiny::icon("floppy-disk")
    ),
    shiny::downloadButton(
        outputId = "dl_sprite_128",
        label = "PNG 128px",
        icon = shiny::icon("floppy-disk")
    ),
    shiny::plotOutput("plot_sprite")
)

server <- function(input, output) {

    rv <- shiny::reactiveValues()  # store parts here, but start empty

    create_sprite <- reactive({
        rv$parts <- pick_parts()
        rv$parts |>
            read_sprite_parts() |>
            sprite_parts_to_nr() |>
            draw_sprite()
        rv$hash <- rlang::hash(rv$parts)
        cat(rv$hash, sep = "\n")
    }) |>
        shiny::bindEvent(
            input$btn_reroll,  # fire on button press
            ignoreNULL = FALSE  # also fire if input is NULL (i.e. on startup)
        )

    output$plot_sprite <- shiny::renderPlot(create_sprite())

    output$dl_sprite_16 <- shiny::downloadHandler(
        filename = \() paste0("sprite_", rv$hash, "_16px.png"),
        content = \(file) {
            px <- 16
            png(file, width = px, height = px)
            rv$parts |>
                read_sprite_parts() |>
                sprite_parts_to_nr() |>
                draw_sprite()
            dev.off()
        })

    output$dl_sprite_128 <- shiny::downloadHandler(
        filename = \() paste0("sprite_", rv$hash, "_256px.png"),
        content = \(file) {
            px <- 256
            png(file, width = px, height = px)
            rv$parts |>
                read_sprite_parts() |>
                sprite_parts_to_nr() |>
                draw_sprite()
            dev.off()
        })

}

shiny::shinyApp(ui, server)
