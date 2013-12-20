function [] = plotPerformanceMetrics(eobj, edelta, eq, er, ev, ep)
    
    figure;
    plot(eobj,'s','MarkerSize',4);
    hold on;
    plot(ones(numel(eobj))*mean(eobj),'-r','LineWidth',4);
    legend('Individual experiment datapoints', 'Average');
    ylabel('Percent objective error');
    xlabel('Experiment #');
    title('Absolute percent errors on the objective');

    figure;
    plot(edelta,'s','MarkerSize',4);
    hold on;
    plot(ones(numel(edelta))*mean(edelta),'-r','LineWidth',4);
    legend('Individual experiment datapoints', 'Average');
    ylabel('Absolute percent phase length error');
    xlabel('Experiment #');
    title('Absolute percent error on phase lengths');
    
    figure;
    plot(eq,'s','MarkerSize',4);
    hold on;
    plot(ones(numel(eq))*mean(eq),'-r','LineWidth',4);
    legend('Individual experiment datapoints', 'Average');
    ylabel('Queue length error');
    xlabel('Experiment #');
    title('Queue length errors');

    figure;
    plot(er,'s','MarkerSize',4);
    hold on;
    plot(ones(numel(er))*mean(er),'-r','LineWidth',4);
    legend('Individual experiment datapoints', 'Average');
    ylabel('Residual value');
    xlabel('Experiment #');
    title('Residual errors');
    
    figure;
    plot(ev,'s','MarkerSize',4);
    hold on;
    plot(ones(numel(ev))*mean(ev),'-r','LineWidth',4);
    legend('Individual experiment datapoints', 'Average');
    ylabel('Infeasibility value');
    xlabel('Experiment #');
    title('Infeasibility errors');
    
    figure;
    plot(ep,'s','MarkerSize',4);
    hold on;
    plot(ones(numel(ep))*mean(ep),'-r','LineWidth',4);
    legend('Individual experiment datapoints', 'Average');
    ylabel('Absolute percent error');
    xlabel('Experiment #');
    title('Policy errors');