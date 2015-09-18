function model = Kronecker_rand(d, bit, matrix_size, flag)
    global index;
    rng(index);
    if(iscell(matrix_size))
        for i = 1:length(matrix_size)
            A = randn(matrix_size{i}(2));
            if(flag == 1)
                [Q,R] = qr(A);
                model.Q{i,1} = Q(1:matrix_size{i}(1),:);
            elseif(flag == 2)
                model.Q{i,1} = eye(matrix_size{i}(1));
            else
                model.Q{i,1} = A(1:matrix_size{i}(1),:);
            end
        end
    else
        if(bit==d)
          add2flag = false;
          if(matrix_size==4)
              if(mod(int32(log(d)/log(2)),2)==1)
                  add2flag = true;
                  d = d/2;
                  bit = bit/2;
              end
          end
          matrix_number = log(d)/log(matrix_size);
          matrix_height = int32(nthroot(bit,matrix_number));
          matrix_number = int32(matrix_number);
        
          for i = 1:matrix_number
              A = randn(matrix_size);
              if(flag == 1)
                [Q,R] = qr(A);
                model.Q{i,1} = Q(1:matrix_height,:);
              elseif(flag == 2)
                model.Q{i,1} = eye(matrix_height);
              else
                model.Q{i,1} = A(1:matrix_height,:);
              end
          end
          if(add2flag)
              A = randn(2);
              if(flag == 1)
                  [Q,R] = qr(A);
                  model.Q{matrix_number+1,1} = Q;
              elseif(flag == 2)
                model.Q{matrix_number+1,1} = eye(2);
              else
                model.Q{matrix_number+1,1} = A;
              end
          end
        else
          scale_number = 0;
          while (bit<d)
              scale_number = scale_number+1;
              d = d./(matrix_size*2);
              bit = bit./matrix_size;
          end
          add2flag = false;
          if(matrix_size==4)
              if(mod(int32(log(d)/log(2)),2)==1)
                  add2flag = true;
                  d = d/2;
                  bit = bit/2;
              end
          end
          
          matrix_number = log(d)/log(matrix_size);
          matrix_height = int32(nthroot(bit,matrix_number));
          matrix_number = int32(matrix_number);
          
          for i = 1:matrix_number
              A = randn(matrix_size);
              if(flag == 1)
                [Q,R] = qr(A);
                model.Q{i,1} = Q(1:matrix_height,:);
              elseif(flag == 2)
                model.Q{i,1} = eye(matrix_height);
              else
                model.Q{i,1} = A(1:matrix_height,:);
              end
          end
          
          if(add2flag)
              A = randn(2);
              if(flag == 1)
                  [Q,R] = qr(A);
                  model.Q{matrix_number+1,1} = Q;
              elseif(flag == 2)
                model.Q{matrix_number+1,1} = eye(2);
              else
                model.Q{matrix_number+1,1} = A;
              end
              matrix_number = matrix_number+1;
          end
          
          if(scale_number>0)
              for i = 1:scale_number
                  A = randn(matrix_size*2);
                  if(flag == 1)
                    [Q,R] = qr(A);
                     model.Q{matrix_number+i,1} = Q(1:matrix_size,:);
                  elseif(flag == 2)
                    model.Q{matrix_number+i,1} = eye(2);
                    model.Q{matrix_number+i,1} = ...
                        model.Q{matrix_number+i,1}(1:matrix_size,:);
                  else
                    model.Q{matrix_number+i,1} = A(1:matrix_size,:);
                  end
              end
          end
        end
    end
end
