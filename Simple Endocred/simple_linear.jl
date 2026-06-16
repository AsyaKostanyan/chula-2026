using Pkg
Pkg.activate("venv")

using Dynare
using PATHSolver
using DataFrames
using Dates
using Plots

# --- Set backend ---
gr()

# --- Step 1: Define Model Files ---
model_files = [
    "simple_linear.mod",
]

# --- Step 2: Run Dynare Models ---
results = Dict{String, Any}()
for model in model_files
    if isfile(model)
        println("Running model: ", model)
        results[model] = eval(Meta.parse("@dynare \"$model\""))
        println("Finished: ", model, "\n")
    else
        println("Model file not found: ", model)
    end
end

# --- Step 3: Extract Data into DataFrames ---
df_models = Dict()
for model in keys(results)
    df_models[model] = DataFrame(results[model].results.model_results[1].simulations[1].data)
end

# --- Step 4: Generate Quarterly Time Index (2025Q1–2035Q2) ---
time_index = (Date(2025,2):Quarter(1):Date(2035,3))[1:40]
formatted_labels = [string(year(d)) * "-Q" * string(month(d) ÷ 3 + 1) for d in time_index]

# --- Step 5: Plot Variables and Colors ---
variables_to_plot = [:RS, :Y, :PIE, :UNR]
model_colors = Dict(
    "simple_linear.mod" => :blue
)

# --- Step 6: Create 2x2 Grid Plot (No Legends) ---
plot_grid = plot(layout=(2,2), size=(900,700), legend=false)

for (i, var) in enumerate(variables_to_plot)
    for (model, df) in df_models
        if haskey(model_colors, model)
            y = df[!, var][1:40]  # Use the full 40 quarters, starting from 2025Q1
            plot!(1:40, y,
                  label="", lw=2, color=model_colors[model],
                  subplot=i, xrotation=90)
        end
    end
    title!(subplot=i, string(var))
    xticks!(subplot=i, 1:4:40, formatted_labels[1:4:40])
end

# --- Step 7: Save and Display ---
savefig(plot_grid, "simple_linear.png")
display(plot_grid)
