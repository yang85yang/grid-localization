function showProbabilities( fig, probs, xt)
%SHOWPROBABILITIES Show the grid of probabilities, i.e., the 2D PDF
%   Detailed explanation goes here

    if (nargin <3)
        xt = [];
    end

    probs = flip(probs);

    figure(fig), clf;
    
    % If probs is has a depth, we have to plot each layer
    K = size(probs,3);
    
    for i = 1:K
        drawLayer(probs,i,K,xt);
    end
end

function drawLayer( all_probs, layer, total_layers, xt )

    % access the correct layer
    probs = all_probs(:,:,layer)/sum(all_probs(:));

    % Figure out how many subplots are needed
    n = ceil(sqrt(total_layers));
    
    % Select the correct subplot
    subplot(n,n,layer);
    
    N = size(probs,1); % num of rows
    M = size(probs,2); % num of cols
    
    % Using meshgrid puts center of cell as (x, y)
    [X, Y] = meshgrid(-0.5:1:((N-1)+0.5));
    
    % Expand the map slightly so it all shows up
    C = [probs zeros(N,1); zeros(1,M+1)];

    % Draw the pseudocolor (checkerboard) plot
    h = pcolor(X,Y,C);
    colormap(flipud(gray));
    colorbar;
    caxis([0 max(all_probs(:))]);
    
    % Make visually easy to see
    set(h, 'EdgeColor', 'k');
    set(h, 'LineStyle', ':');
    axis square % make the aspect ratio square

    if (total_layers == 4)
        titles = {'\theta = 0^{\circ}', '\theta = 90^{\circ}',...
              '\theta = 180^{\circ}', '\theta = 270^{\circ}'};
        
        title(titles{layer});
    end
    
    % Add true robot position (*)
    if (nargin == 4 && ~isempty(xt) && (xt(3)/90)+1 == layer)
        hold on;
        h = plot(xt(1),xt(2),'w*');
        set(h, 'MarkerSize', 20);
        set(h, 'LineWidth', 4);
    end
end
