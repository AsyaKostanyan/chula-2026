function results = simulation_sheet(results, oo_, M_)
    k = 1:M_.orig_endo_nbr;
    if length(fieldnames(results)) > 0
        results.endo = vertcat(results.endo, oo_.endo_simul(k, 2)');
        results.exo = vertcat(results.exo, oo_.exo_simul(2, :));
        results.period = results.period + 1;
    else
        results.endo = oo_.endo_simul(k, 1:2)';
        results.exo = oo_.exo_simul(1:2, :);
        results.period = 1;
    end
    period = results.period;
    exogenous = vertcat(results.exo, oo_.exo_simul(3:end,:));
    endogenous = vertcat(results.endo, oo_.endo_simul(k, 3:end)');
    datacells = vertcat(M_.exo_names', num2cell(exogenous));
    datacells = horzcat(datacells, vertcat(M_.endo_names(k)', num2cell(endogenous(:,k))));
    n = size(datacells, 1);
    firstcol = mat2cell(repmat(' ', n, 1), ones(n, 1), 1);
    firstcol{period+2} = '*';
    pnbr = num2str((0:n-2)');
    secondcol = vertcat([' '], mat2cell(pnbr, ones(n-1, 1), size(pnbr,2)));
    writecell(horzcat(firstcol, secondcol, datacells),... 
              strcat(M_.fname, '.xlsx'),'Sheet', sprintf('Period_%d', period));
    