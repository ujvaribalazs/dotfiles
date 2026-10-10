return {
    {
        "goropikari/plantuml.nvim",
        dependencies = {
            "goropikari/LibDeflate.nvim",
        },
        opts = {
            base_url = "https://www.plantuml.com/plantuml",
            reload_events = { "BufWritePre" },
            viewer = "xdg-open",
            docker_image = "plantuml/plantuml-server:tomcat",
        },
    },
}
