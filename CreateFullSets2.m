clear all

vol = MatrixFromNii2('trial15_60_w1_volume_TRANS.nii'); % Change
seg = MatrixFromNii2('trial15_60_w1_seg_TRANS.nii'); % Change

%% Find min and max x, y, z

buffer = 5;

minx = find(squeeze(any(any(vol, 2), 3)), 1, 'first');
maxx = find(squeeze(any(any(vol, 2), 3)), 1, 'last');

miny = zeros([1, maxx - minx + 1]);
maxy = zeros([1, maxx - minx + 1]);
minz = zeros([1, maxx - minx + 1]);
maxz = zeros([1, maxx - minx + 1]);

index = 1;
for x = minx:maxx
    miny(index) = find(squeeze(any(vol(x, :, :), 3)), 1, 'first');
    maxy(index) = find(squeeze(any(vol(x, :, :), 3)), 1, 'last');
    minz(index) = find(squeeze(any(vol(x, :, :), 2)), 1, 'first');
    maxz(index) = find(squeeze(any(vol(x, :, :), 2)), 1, 'last');
    index = index + 1;
end

miny = miny - buffer;
maxy = maxy + buffer;
minz = minz - buffer;
maxz = maxz + buffer;

minx = max(minx, 2);
miny = max(miny, 2);
minz = max(minz, 2);
maxx = min(maxx, size(vol, 1) - 1);
maxy = min(maxy, size(vol, 2) - 1);
maxz = min(maxz, size(vol, 3) - 1);

% %% Jank video, to see bounding box
% 
% x = minx:maxx;
% y = 1:size(vol, 2);
% z = 1:size(vol, 3);
% 
% maxval = 200;
% 
% for index = 1:size(x,2)-1
%     figure(1)
%     blank = zeros([482, 395]);
%     im = double(squeeze(vol(x(index), :, :)));
%     blank(miny(index), :) = maxval;
%     blank(maxy(index), :) = maxval;
%     blank(:, minz(index)) = maxval;
%     blank(:, maxz(index)) = maxval;
%     imagesc(max(im, blank)), colormap(gray);
%     pause(0.01)
% end

%% Generate Full Matrix
yr = maxy-miny+1;
zr = maxz-minz+1;
area = yr.*zr;
n_full = floor(sum(area)*1.05); % fudge to keep it bigger (since it's not big enough
full = zeros([n_full, 14], 'single');

index = 1;
findex = 1;
for x = minx:maxx
   comb = allcomb(x, miny(index):maxy(index), minz(index):maxz(index)); % Not a predictable size because y and z can be the same (so drops one combination)
   full(findex:findex+size(comb,1)-1, 1:3) = comb;
   index = index + 1;
   findex = findex + size(comb,1);
end

n_full = findex-1;
full = full(1:n_full, :);

%% Generate features

full(:, 4) = full(:,1) + 3*randn([n_full, 1]);
full(:, 5) = full(:,2) + 3*randn([n_full, 1]);
full(:, 6) = full(:,3) + 3*randn([n_full, 1]);

full(:, 7) = vol(sub2ind(size(vol), full(:, 1), full(:, 2), full(:, 3)));
full(:, 8) = vol(sub2ind(size(vol), full(:, 1)+1, full(:, 2), full(:, 3)));
full(:, 9) = vol(sub2ind(size(vol), full(:, 1)-1, full(:, 2), full(:, 3)));
full(:, 10) = vol(sub2ind(size(vol), full(:, 1), full(:, 2)+1, full(:, 3)));
full(:, 11) = vol(sub2ind(size(vol), full(:, 1), full(:, 2)-1, full(:, 3)));
full(:, 12) = vol(sub2ind(size(vol), full(:, 1), full(:, 2), full(:, 3)+1));
full(:, 13) = vol(sub2ind(size(vol), full(:, 1), full(:, 2), full(:, 3)-1));
full(:, 14) = seg(sub2ind(size(seg), full(:, 1), full(:, 2), full(:, 3)));


%% Sample 10% data, maintaining relative proportionality of inputs

percent = 0.1; % 10%

n_sample = round(n_full * percent);
sample = zeros([n_sample, 14], 'single');

Groups = findgroups(full(:,14));
findex = 1;
for g = 1:max(Groups);
    part = full(Groups == g, :);
    indices = datasample(1:size(part,1), round(size(part,1) * percent), 'Replace', false);
    sample(findex:findex+numel(indices)-1, :) = part(indices, :);
    findex = findex + numel(indices);
end

%% Save Sample
name = 'full_60_w1'; % Change
save([name, '_sample.mat'], 'sample', '-mat', '-v6');

% %% Save Full
% name = 'full_30_fs'; % Change
% save([name, '.mat'], 'full', '-mat', '-v6');
% 

