library(shiny)
library(ggplot2)
library(e1071)
library(rmarkdown)

server <- function(input, output, session) {
  
  dane_wpisane <- reactiveVal(data.frame(
    Imie = character(),
    CenaZaGodz = numeric(),
    IloscLekcji = integer(),
    dataPierwszejLekcji = as.Date(character()),
    stringsAsFactors = FALSE
  ))
  
  historia_dodanych <- reactiveVal(list())
  
  output$dane <- renderDataTable({dane_wpisane()})
    
  observeEvent(input$zatwierdzButton, {
      dane_nowe <- data.frame(
        Imie = input$imie,
        CenaZaGodz = input$cena,
        IloscLekcji = input$iloscLekcji,
        DataPierwszejLekcji = as.Date(input$dataPierwszejLekcji, format = "%Y-%m-%d")
      )
      
      dane_wpisane(rbind(dane_wpisane(), dane_nowe))
      updateTextInput(session, "imie", value = "")
      updateNumericInput(session, "cena", value = 0)
      updateNumericInput(session, "iloscLekcji", value = 0)
      updateDateInput(session, "dataPierwszejLekcji", value = Sys.Date())
      historia <- historia_dodanych()
      historia[[length(historia) + 1]] <- dane_nowe
      historia_dodanych(historia)
    })
  
  
  
  
  
  
  observeEvent(input$cofnijButton, {
    
    historia <- historia_dodanych()
    
    if (length(historia) > 0) {
      dane_wpisane(dane_wpisane()[-nrow(dane_wpisane()), ])
      historia_dodanych(historia[-length(historia)])
    }
  })
  
  observeEvent(input$resetButton, {
    dane_wpisane(data.frame(Imie = character(), CenaZaGodz = numeric(), IloscLekcji = integer(), dataPierwszejLekcji = as.Date(character()), stringsAsFactors = FALSE))
    historia_dodanych(list())
    })
    
  output$stats <- renderText({
    ciag_cen <- rep(dane_wpisane()$CenaZaGodz, times = dane_wpisane()$IloscLekcji)
      paste(
        "- Suma ilości lekcji:", sum(dane_wpisane()$IloscLekcji),
        "\n- Średnia przychodu/godz:", round(mean(ciag_cen), 2),
        "\n- Mediana przychodu/godz:", round(median(ciag_cen), 2),
        "\n- Odchylenie standardowe przychodu/godz:", round(sd(ciag_cen), 2),
        "\n- Wariancja przychodu/godz:", round(var(ciag_cen), 2),
        "\n- Skośność przychodu/godz:", round(skewness(ciag_cen), 2),
        "\n- Kurtoza przychodu/godz:", round(kurtosis(ciag_cen), 2))
    })
  output$boxplot <- renderPlot({
    
    ciag_cen <- rep(dane_wpisane()$CenaZaGodz, times = dane_wpisane()$IloscLekcji)
    
    ggplot(data.frame(ciag_cen), aes(x = ciag_cen)) +
      geom_boxplot(position = position_dodge(width = 0.8), width = 0.2, fill = "lightblue", color = "darkblue", alpha = 0.7) +
      labs(title = "Cena za lekcję", x = "Cena za godzinę (zł)") + theme(axis.text.y = element_blank())})
  
  output$przychod <- renderText({
    paste("Suma przychodu: ", sum(dane_wpisane()$CenaZaGodz * dane_wpisane()$IloscLekcji))})
  
  output$histogram1 <- renderPlot({
    ggplot(dane_wpisane(), aes(x = Imie, y = CenaZaGodz * IloscLekcji)) +
      geom_bar(stat = "identity", position = "dodge", fill = "lightblue", color = "darkblue", alpha = 0.7) +
      labs(title = "Przychód na ucznia w zł", x = "Uczeń", y = "Przychód (zł)") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  output$histogram2 <- renderPlot({
    dni <- as.numeric(difftime(Sys.Date(), dane_wpisane()$DataPierwszejLekcji, units = "days"))
    if (length(dni) > 0) {
      ggplot(dane_wpisane(), aes(x = Imie, y = (CenaZaGodz * IloscLekcji) / dni)) +
        geom_bar(stat = "identity", position = "dodge", fill = "lightblue", color = "darkblue", alpha = 0.7) +
        labs(title = "Przychód od ucznia na dzień w zł", x = "Uczeń", y = "Przychód na dzień (zł)") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    } else {
      # Handle the case when DataPierwszejLekcji is empty
      ggplot() + labs(title = "No data available", x = "", y = "")
    }
  })
  
}

