using DICE
import JuMP
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

model = JuMP.Model();
modelrr = JuMP.Model();
vanilla_opt = options(v2013R());
rr_opt = options(v2013R(RockyRoad));
vanilla_params = DICE.generate_parameters(vanilla_opt);
rr_params = DICE.generate_parameters(rr_opt, modelrr);

@testset "Types Display" begin
    @testset "Flavour" begin
        @test sprint(show, Vanilla) == "Vanilla flavour"
        @test sprint(show, RockyRoad) == "Rocky Road flavour"
    end
    @testset "Version" begin
        @test sprint(show, v2013R()) == "v2013R (Vanilla flavour)"
        @test sprint(show, v2013R(RockyRoad)) == "v2013R (Rocky Road flavour)"
        @test sprint(show, v2016R()) == "v2016R"
    end
    @testset "Scenario" begin
        @test sprint(show, BasePrice) == "Base (current policy) carbon price"
        @test sprint(show, OptimalPrice) == "Optimal carbon price"
        @test sprint(show, Limit2Degrees) == "Limit warming to 2° with damages"
        @test sprint(show, Stern) == "Stern"
        @test sprint(show, SternCalibrated) == "Calibrated Stern"
        @test sprint(show, Copenhagen) == "Copenhagen participation"
    end
    @testset "Default Options and Parameters" begin
        @test sprint(show, "text/plain", vanilla_opt) == "Options for Vanilla 2013R version\nTime step\nN: 60, tstep: 5\nPreferences\nα: 1.45, ρ: 0.015\nPopulation and Technology\nγₑ: 0.3, pop₀: 6838, popadj: 0.134, popasym: 10500, δk: 0.1\nq₀: 63.69, k₀: 135.0, a₀: 3.8, ga₀: 0.079, δₐ: 0.006\nEmissions Parameters\ngσ₁: -0.01, δσ: -0.001, eland₀: 3.3\ndeland: 0.2, e₀: 33.61, μ₀: 0.039\nCarbon Cycle\nmat₀: 830.4, mu₀: 1527.0, ml₀: 10010.0\nmateq: 588.0, mueq: 1350.0, mleq: 10000.0\nFlow Parameters\nϕ₁₂: 0.088, ϕ₂₃: 0.0025\nClimate Model Parameters\nt2xco2: 2.9, fₑₓ0: 0.25, fₑₓ1: 0.7\ntocean₀: 0.0068, tatm₀: 0.8, ξ₁: 0.098\nξ₃: 0.088, ξ₄: 0.025, η: 3.8\nClimate Damage Parameters\nψ₁: 0.0, ψ₂: 0.00267, ψ₃: 2.0\nAbatement Cost\nθ₂: 2.8, pback: 344.0, gback: 0.025, limμ: 1.2\ntnopol: 45.0, cprice₀: 1.0, gcprice: 0.02\nParticipation Parameters\nperiodfullpart: 21.0, partfract2010: 1.0, partfractfull: 1.0\nFossil Fuel Availability\nfosslim: 6000.0\nScaling Parameters\nscale1: 0.016408662, scale2: -3855.106895"
        @test sprint(show, "text/plain", rr_opt) == "Options for Rocky Road 2013R version\nTime step\nN: 60, tstep: 5\nPreferences\nα: 1.45, ρ: 0.015\nPopulation and Technology\nγₑ: 0.3, pop₀: 6838, popadj: 0.134, popasym: 10500, δk: 0.1\nq₀: 63.69, k₀: 135.0, a₀: 3.8, ga₀: 0.079, δₐ: 0.006\nEmissions Parameters\ngσ₁: -0.01, δσ: -0.001, eland₀: 3.3\ndeland: 0.2, e₀: 33.61, μ₀: 0.039\nCarbon Cycle\nmat₀: 830.4, mu₀: 1527.0, ml₀: 10010.0\nmateq: 588.0, mueq: 1350.0, mleq: 10000.0\nFlow Parameters\nϕ₁₂: 0.088, ϕ₂₃: 0.0025\nClimate Model Parameters\nt2xco2: 2.9, fₑₓ0: 0.25, fₑₓ1: 0.7\ntocean₀: 0.0068, tatm₀: 0.8, ξ₁₀: 0.098, ξ₁β: 0.01243\nξ₁: 0.098, ξ₃: 0.088, ξ₄: 0.025, η: 3.8\nClimate Damage Parameters\nψ₁₀: 0.0, ψ₂₀: 0.00267, ψ₁: 0.0, ψ₂: 0.0, ψ₃: 2.0\nAbatement Cost\nθ₂: 2.8, pback: 344.0, gback: 0.025, limμ: 1.2\ntnopol: 45.0, cprice₀: 1.0, gcprice: 0.02\nParticipation Parameters\nperiodfullpart: 21.0, partfract2010: 1.0, partfractfull: 1.0\nFossil Fuel Availability\nfosslim: 6000.0\nScaling Parameters\nscale1: 0.016408662, scale2: -3855.106895"
        @test sprint(show, "text/plain", vanilla_params) == "Calculated Parameters for Vanilla 2013R\nOptimal savings rate: 0.2582781456953642\nCarbon cycle transition matrix coefficients\nϕ₁₁: 0.912, ϕ₂₁: 0.03832888888888889, ϕ₂₂: 0.9591711111111112, ϕ₃₂: 0.0003375, ϕ₃₃: 0.9996625\n2010 Carbon intensity: 0.5491283628802297\nClimate model parameter: 1.3103448275862069\nBackstop price: [344.0, 335.4, 327.015, 318.84, 310.869, 303.097, 295.519, 288.132, 280.928, 273.905, 267.057, 260.381, 253.871, 247.525, 241.337, 235.303, 229.421, 223.685, 218.093, 212.641, 207.325, 202.141, 197.088, 192.161, 187.357, 182.673, 178.106, 173.653, 169.312, 165.079, 160.952, 156.928, 153.005, 149.18, 145.451, 141.814, 138.269, 134.812, 131.442, 128.156, 124.952, 121.828, 118.782, 115.813, 112.918, 110.095, 107.342, 104.659, 102.042, 99.4912, 97.0039, 94.5788, 92.2143, 89.909, 87.6613, 85.4697, 83.333, 81.2497, 79.2184, 77.238]\nGrowth rate of productivity: [0.079, 0.0766652, 0.0743994, 0.0722006, 0.0700667, 0.0679959, 0.0659863, 0.0640362, 0.0621436, 0.060307, 0.0585246, 0.056795, 0.0551164, 0.0534875, 0.0519067, 0.0503726, 0.0488839, 0.0474392, 0.0460371, 0.0446765, 0.0433561, 0.0420748, 0.0408313, 0.0396245, 0.0384534, 0.037317, 0.0362141, 0.0351438, 0.0341051, 0.0330972, 0.032119, 0.0311697, 0.0302485, 0.0293546, 0.028487, 0.0276451, 0.026828, 0.0260352, 0.0252657, 0.024519, 0.0237943, 0.0230911, 0.0224087, 0.0217464, 0.0211037, 0.02048, 0.0198747, 0.0192873, 0.0187173, 0.0181641, 0.0176273, 0.0171063, 0.0166007, 0.0161101, 0.015634, 0.0151719, 0.0147235, 0.0142884, 0.0138661, 0.0134563]\nEmissions from deforestation: [3.3, 2.64, 2.112, 1.6896, 1.35168, 1.08134, 0.865075, 0.69206, 0.553648, 0.442919, 0.354335, 0.283468, 0.226774, 0.181419, 0.145136, 0.116108, 0.0928867, 0.0743094, 0.0594475, 0.047558, 0.0380464, 0.0304371, 0.0243497, 0.0194798, 0.0155838, 0.012467, 0.00997364, 0.00797891, 0.00638313, 0.0051065, 0.0040852, 0.00326816, 0.00261453, 0.00209162, 0.0016733, 0.00133864, 0.00107091, 0.000856729, 0.000685383, 0.000548307, 0.000438645, 0.000350916, 0.000280733, 0.000224586, 0.000179669, 0.000143735, 0.000114988, 9.19906e-5, 7.35925e-5, 5.8874e-5, 4.70992e-5, 3.76793e-5, 3.01435e-5, 2.41148e-5, 1.92918e-5, 1.54335e-5, 1.23468e-5, 9.87741e-6, 7.90193e-6, 6.32154e-6]\nAvg utility social discout rate: [1.0, 0.92826, 0.861667, 0.799852, 0.74247, 0.689206, 0.639762, 0.593866, 0.551262, 0.511715, 0.475005, 0.440928, 0.409296, 0.379933, 0.352677, 0.327376, 0.30389, 0.282089, 0.261852, 0.243067, 0.225629, 0.209443, 0.194417, 0.18047, 0.167523, 0.155505, 0.144349, 0.133994, 0.124381, 0.115458, 0.107175, 0.0994863, 0.0923492, 0.0857241, 0.0795743, 0.0738657, 0.0685666, 0.0636476, 0.0590816, 0.0548431, 0.0509086, 0.0472565, 0.0438663, 0.0407194, 0.0377982, 0.0350865, 0.0325694, 0.0302329, 0.028064, 0.0260507, 0.0241818, 0.022447, 0.0208367, 0.0193419, 0.0179543, 0.0166663, 0.0154706, 0.0143608, 0.0133305, 0.0123742]\nBase case carbon price: [1.0, 1.10408, 1.21899, 1.34587, 1.48595, 1.64061, 1.81136, 1.99989, 2.20804, 2.43785, 2.69159, 2.97173, 3.28103, 3.62252, 3.99956, 4.41584, 4.87544, 5.38288, 5.94313, 6.5617, 7.24465, 7.99867, 8.83118, 9.75034, 10.7652, 11.8856, 13.1227, 14.4885, 15.9965, 17.6614, 19.4996, 21.5291, 23.7699, 26.2439, 28.9754, 31.9912, 35.3208, 38.9971, 43.0559, 47.5372, 52.4849, 57.9476, 63.9788, 70.6378, 77.9898, 86.107, 95.0691, 104.964, 115.889, 127.951, 141.268, 155.971, 172.205, 190.128, 209.916, 231.765, 255.887, 282.52, 311.925, 344.39]\nPopulation and labour: [6838.0, 7242.49, 7612.06, 7947.31, 8249.55, 8520.56, 8762.43, 8977.44, 9167.89, 9336.08, 9484.22, 9614.42, 9728.61, 9828.59, 9916.01, 9992.34, 10058.9, 10116.9, 10167.4, 10211.4, 10249.6, 10282.8, 10311.6, 10336.7, 10358.4, 10377.3, 10393.6, 10407.8, 10420.1, 10430.8, 10440.0, 10448.1, 10455.0, 10461.0, 10466.2, 10470.8, 10474.7, 10478.1, 10481.0, 10483.5, 10485.7, 10487.7, 10489.3, 10490.7, 10492.0, 10493.1, 10494.0, 10494.8, 10495.5, 10496.1, 10496.6, 10497.1, 10497.5, 10497.8, 10498.1, 10498.4, 10498.6, 10498.8, 10498.9, 10499.1]\nTotal factor productivity: [3.8, 4.12595, 4.46853, 4.82771, 5.2034, 5.59545, 6.00368, 6.42783, 6.8676, 7.32266, 7.79261, 8.27702, 8.77542, 9.2873, 9.81212, 10.3493, 10.8983, 11.4584, 12.0291, 12.6096, 13.1993, 13.7975, 14.4035, 15.0167, 15.6362, 16.2616, 16.8919, 17.5266, 18.165, 18.8064, 19.4502, 20.0956, 20.7421, 21.3891, 22.036, 22.6821, 23.327, 23.9701, 24.6108, 25.2487, 25.8834, 26.5143, 27.141, 27.7631, 28.3803, 28.9921, 29.5983, 30.1985, 30.7924, 31.3797, 31.9603, 32.5337, 33.1, 33.6587, 34.2098, 34.7532, 35.2886, 35.8159, 36.3351, 36.846]\nΔσ: [-0.01, -0.0099501, -0.00990045, -0.00985105, -0.00980189, -0.00975298, -0.00970431, -0.00965589, -0.0096077, -0.00955976, -0.00951206, -0.00946459, -0.00941736, -0.00937037, -0.00932361, -0.00927709, -0.00923079, -0.00918473, -0.0091389, -0.0090933, -0.00904792, -0.00900277, -0.00895785, -0.00891315, -0.00886867, -0.00882442, -0.00878038, -0.00873657, -0.00869297, -0.0086496, -0.00860643, -0.00856349, -0.00852076, -0.00847824, -0.00843593, -0.00839384, -0.00835195, -0.00831027, -0.00826881, -0.00822754, -0.00818649, -0.00814564, -0.00810499, -0.00806455, -0.0080243, -0.00798426, -0.00794442, -0.00790478, -0.00786533, -0.00782609, -0.00778703, -0.00774818, -0.00770951, -0.00767104, -0.00763276, -0.00759468, -0.00755678, -0.00751907, -0.00748155, -0.00744422]\nσ: [0.549128, 0.522347, 0.496996, 0.472992, 0.45026, 0.428725, 0.408319, 0.38898, 0.370647, 0.353262, 0.336774, 0.321132, 0.306289, 0.292201, 0.278827, 0.266126, 0.254064, 0.242604, 0.231715, 0.221365, 0.211526, 0.20217, 0.193271, 0.184806, 0.176751, 0.169084, 0.161786, 0.154837, 0.148219, 0.141914, 0.135908, 0.130183, 0.124727, 0.119525, 0.114564, 0.109832, 0.105318, 0.10101, 0.0968992, 0.0929747, 0.0892276, 0.085649, 0.0822307, 0.078965, 0.0758442, 0.0728615, 0.07001, 0.0672836, 0.0646762, 0.062182, 0.0597958, 0.0575124, 0.0553269, 0.0532348, 0.0512316, 0.0493133, 0.0474758, 0.0457154, 0.0440286, 0.0424121]\nθ₁: [0.0674643, 0.0625697, 0.0580447, 0.0538603, 0.0499898, 0.046409, 0.0430951, 0.0400277, 0.0371875, 0.0345572, 0.0321207, 0.0298631, 0.0277707, 0.025831, 0.0240325, 0.0223644, 0.020817, 0.0193811, 0.0180484, 0.0168112, 0.0156623, 0.0145953, 0.0136041, 0.012683, 0.0118269, 0.0110311, 0.0102911, 0.00960283, 0.00896257, 0.00836683, 0.00781237, 0.00729624, 0.00681566, 0.00636811, 0.0059512, 0.00556277, 0.00520078, 0.00486337, 0.00454879, 0.00425545, 0.00398184, 0.00372659, 0.00348842, 0.00326613, 0.00305862, 0.00286488, 0.00268394, 0.00251493, 0.00235704, 0.00220949, 0.00207158, 0.00194266, 0.00182212, 0.00170939, 0.00160394, 0.00150528, 0.00141296, 0.00132656, 0.00124567, 0.00116994]\nExogenious forcing: [0.25, 0.275, 0.3, 0.325, 0.35, 0.375, 0.4, 0.425, 0.45, 0.475, 0.5, 0.525, 0.55, 0.575, 0.6, 0.625, 0.65, 0.675, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45]\nFraction of emissions in control regieme: [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]"
        @test sprint(show, "text/plain", rr_params) == "Calculated Parameters for Rocky Road 2013R\nOptimal savings rate: 0.2582781456953642\nCarbon cycle transition matrix coefficients\nϕ₁₁: 0.912, ϕ₂₁: 0.03832888888888889, ϕ₂₂: 0.9591711111111112, ϕ₃₂: 0.0003375, ϕ₃₃: 0.9996625\n2010 Carbon intensity: 0.5491283628802297\nClimate model parameter: 1.3103448275862069\nTransient TSC Correction: 0.098\nBackstop price: [344.0, 335.4, 327.015, 318.84, 310.869, 303.097, 295.519, 288.132, 280.928, 273.905, 267.057, 260.381, 253.871, 247.525, 241.337, 235.303, 229.421, 223.685, 218.093, 212.641, 207.325, 202.141, 197.088, 192.161, 187.357, 182.673, 178.106, 173.653, 169.312, 165.079, 160.952, 156.928, 153.005, 149.18, 145.451, 141.814, 138.269, 134.812, 131.442, 128.156, 124.952, 121.828, 118.782, 115.813, 112.918, 110.095, 107.342, 104.659, 102.042, 99.4912, 97.0039, 94.5788, 92.2143, 89.909, 87.6613, 85.4697, 83.333, 81.2497, 79.2184, 77.238]\nGrowth rate of productivity: [0.079, 0.0766652, 0.0743994, 0.0722006, 0.0700667, 0.0679959, 0.0659863, 0.0640362, 0.0621436, 0.060307, 0.0585246, 0.056795, 0.0551164, 0.0534875, 0.0519067, 0.0503726, 0.0488839, 0.0474392, 0.0460371, 0.0446765, 0.0433561, 0.0420748, 0.0408313, 0.0396245, 0.0384534, 0.037317, 0.0362141, 0.0351438, 0.0341051, 0.0330972, 0.032119, 0.0311697, 0.0302485, 0.0293546, 0.028487, 0.0276451, 0.026828, 0.0260352, 0.0252657, 0.024519, 0.0237943, 0.0230911, 0.0224087, 0.0217464, 0.0211037, 0.02048, 0.0198747, 0.0192873, 0.0187173, 0.0181641, 0.0176273, 0.0171063, 0.0166007, 0.0161101, 0.015634, 0.0151719, 0.0147235, 0.0142884, 0.0138661, 0.0134563]\nEmissions from deforestation: [3.3, 2.64, 2.112, 1.6896, 1.35168, 1.08134, 0.865075, 0.69206, 0.553648, 0.442919, 0.354335, 0.283468, 0.226774, 0.181419, 0.145136, 0.116108, 0.0928867, 0.0743094, 0.0594475, 0.047558, 0.0380464, 0.0304371, 0.0243497, 0.0194798, 0.0155838, 0.012467, 0.00997364, 0.00797891, 0.00638313, 0.0051065, 0.0040852, 0.00326816, 0.00261453, 0.00209162, 0.0016733, 0.00133864, 0.00107091, 0.000856729, 0.000685383, 0.000548307, 0.000438645, 0.000350916, 0.000280733, 0.000224586, 0.000179669, 0.000143735, 0.000114988, 9.19906e-5, 7.35925e-5, 5.8874e-5, 4.70992e-5, 3.76793e-5, 3.01435e-5, 2.41148e-5, 1.92918e-5, 1.54335e-5, 1.23468e-5, 9.87741e-6, 7.90193e-6, 6.32154e-6]\nAvg utility social discout rate: [1.0, 0.92826, 0.861667, 0.799852, 0.74247, 0.689206, 0.639762, 0.593866, 0.551262, 0.511715, 0.475005, 0.440928, 0.409296, 0.379933, 0.352677, 0.327376, 0.30389, 0.282089, 0.261852, 0.243067, 0.225629, 0.209443, 0.194417, 0.18047, 0.167523, 0.155505, 0.144349, 0.133994, 0.124381, 0.115458, 0.107175, 0.0994863, 0.0923492, 0.0857241, 0.0795743, 0.0738657, 0.0685666, 0.0636476, 0.0590816, 0.0548431, 0.0509086, 0.0472565, 0.0438663, 0.0407194, 0.0377982, 0.0350865, 0.0325694, 0.0302329, 0.028064, 0.0260507, 0.0241818, 0.022447, 0.0208367, 0.0193419, 0.0179543, 0.0166663, 0.0154706, 0.0143608, 0.0133305, 0.0123742]\nBase case carbon price: [1.0, 1.10408, 1.21899, 1.34587, 1.48595, 1.64061, 1.81136, 1.99989, 2.20804, 2.43785, 2.69159, 2.97173, 3.28103, 3.62252, 3.99956, 4.41584, 4.87544, 5.38288, 5.94313, 6.5617, 7.24465, 7.99867, 8.83118, 9.75034, 10.7652, 11.8856, 13.1227, 14.4885, 15.9965, 17.6614, 19.4996, 21.5291, 23.7699, 26.2439, 28.9754, 31.9912, 35.3208, 38.9971, 43.0559, 47.5372, 52.4849, 57.9476, 63.9788, 70.6378, 77.9898, 86.107, 95.0691, 104.964, 115.889, 127.951, 141.268, 155.971, 172.205, 190.128, 209.916, 231.765, 255.887, 282.52, 311.925, 344.39]\nPopulation and labour: [6838.0, 7242.49, 7612.06, 7947.31, 8249.55, 8520.56, 8762.43, 8977.44, 9167.89, 9336.08, 9484.22, 9614.42, 9728.61, 9828.59, 9916.01, 9992.34, 10058.9, 10116.9, 10167.4, 10211.4, 10249.6, 10282.8, 10311.6, 10336.7, 10358.4, 10377.3, 10393.6, 10407.8, 10420.1, 10430.8, 10440.0, 10448.1, 10455.0, 10461.0, 10466.2, 10470.8, 10474.7, 10478.1, 10481.0, 10483.5, 10485.7, 10487.7, 10489.3, 10490.7, 10492.0, 10493.1, 10494.0, 10494.8, 10495.5, 10496.1, 10496.6, 10497.1, 10497.5, 10497.8, 10498.1, 10498.4, 10498.6, 10498.8, 10498.9, 10499.1]\nTotal factor productivity: [3.8, 4.12595, 4.46853, 4.82771, 5.2034, 5.59545, 6.00368, 6.42783, 6.8676, 7.32266, 7.79261, 8.27702, 8.77542, 9.2873, 9.81212, 10.3493, 10.8983, 11.4584, 12.0291, 12.6096, 13.1993, 13.7975, 14.4035, 15.0167, 15.6362, 16.2616, 16.8919, 17.5266, 18.165, 18.8064, 19.4502, 20.0956, 20.7421, 21.3891, 22.036, 22.6821, 23.327, 23.9701, 24.6108, 25.2487, 25.8834, 26.5143, 27.141, 27.7631, 28.3803, 28.9921, 29.5983, 30.1985, 30.7924, 31.3797, 31.9603, 32.5337, 33.1, 33.6587, 34.2098, 34.7532, 35.2886, 35.8159, 36.3351, 36.846]\nΔσ: [-0.01, -0.0099501, -0.00990045, -0.00985105, -0.00980189, -0.00975298, -0.00970431, -0.00965589, -0.0096077, -0.00955976, -0.00951206, -0.00946459, -0.00941736, -0.00937037, -0.00932361, -0.00927709, -0.00923079, -0.00918473, -0.0091389, -0.0090933, -0.00904792, -0.00900277, -0.00895785, -0.00891315, -0.00886867, -0.00882442, -0.00878038, -0.00873657, -0.00869297, -0.0086496, -0.00860643, -0.00856349, -0.00852076, -0.00847824, -0.00843593, -0.00839384, -0.00835195, -0.00831027, -0.00826881, -0.00822754, -0.00818649, -0.00814564, -0.00810499, -0.00806455, -0.0080243, -0.00798426, -0.00794442, -0.00790478, -0.00786533, -0.00782609, -0.00778703, -0.00774818, -0.00770951, -0.00767104, -0.00763276, -0.00759468, -0.00755678, -0.00751907, -0.00748155, -0.00744422]\nσ: [0.549128, 0.522347, 0.496996, 0.472992, 0.45026, 0.428725, 0.408319, 0.38898, 0.370647, 0.353262, 0.336774, 0.321132, 0.306289, 0.292201, 0.278827, 0.266126, 0.254064, 0.242604, 0.231715, 0.221365, 0.211526, 0.20217, 0.193271, 0.184806, 0.176751, 0.169084, 0.161786, 0.154837, 0.148219, 0.141914, 0.135908, 0.130183, 0.124727, 0.119525, 0.114564, 0.109832, 0.105318, 0.10101, 0.0968992, 0.0929747, 0.0892276, 0.085649, 0.0822307, 0.078965, 0.0758442, 0.0728615, 0.07001, 0.0672836, 0.0646762, 0.062182, 0.0597958, 0.0575124, 0.0553269, 0.0532348, 0.0512316, 0.0493133, 0.0474758, 0.0457154, 0.0440286, 0.0424121]\nθ₁: [0.0674643, 0.0625697, 0.0580447, 0.0538603, 0.0499898, 0.046409, 0.0430951, 0.0400277, 0.0371875, 0.0345572, 0.0321207, 0.0298631, 0.0277707, 0.025831, 0.0240325, 0.0223644, 0.020817, 0.0193811, 0.0180484, 0.0168112, 0.0156623, 0.0145953, 0.0136041, 0.012683, 0.0118269, 0.0110311, 0.0102911, 0.00960283, 0.00896257, 0.00836683, 0.00781237, 0.00729624, 0.00681566, 0.00636811, 0.0059512, 0.00556277, 0.00520078, 0.00486337, 0.00454879, 0.00425545, 0.00398184, 0.00372659, 0.00348842, 0.00326613, 0.00305862, 0.00286488, 0.00268394, 0.00251493, 0.00235704, 0.00220949, 0.00207158, 0.00194266, 0.00182212, 0.00170939, 0.00160394, 0.00150528, 0.00141296, 0.00132656, 0.00124567, 0.00116994]\nExogenious forcing: [0.25, 0.275, 0.3, 0.325, 0.35, 0.375, 0.4, 0.425, 0.45, 0.475, 0.5, 0.525, 0.55, 0.575, 0.6, 0.625, 0.65, 0.675, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45]\nFraction of emissions in control regieme: [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]"
    end
end

#Use same limits for RR case for simplicity
μ_ubound = [if t < 30 1.0 else vanilla_opt.limμ*vanilla_params.partfract[t] end for t in 1:vanilla_opt.N];
vanilla_vars = DICE.model_vars(v2013R(), model, vanilla_opt.N, vanilla_opt.fosslim, μ_ubound, vanilla_params.cpricebase);
rr_vars = DICE.model_vars(v2013R(RockyRoad), modelrr, vanilla_opt.N, vanilla_opt.fosslim, μ_ubound, fill(Inf, vanilla_opt.N));

vanilla_eqs = DICE.model_eqs(v2013R(), model, vanilla_opt, vanilla_params, vanilla_vars);
rr_eqs = DICE.model_eqs(v2013R(RockyRoad), modelrr, rr_opt, rr_params, rr_vars);
@testset "Model Construction" begin
    @testset "Variables" begin
        @test typeof(vanilla_vars) <: DICE.VariablesV2013
        @test typeof(rr_vars) <: DICE.VariablesV2013
        @test supertype(typeof(vanilla_vars)) == supertype(typeof(rr_vars))
    end
    @testset "Equations" begin
        @test typeof(vanilla_eqs) <: DICE.VanillaEquations
        @test typeof(rr_eqs) <: DICE.RockyRoadEquations
        @test supertype(typeof(vanilla_eqs)) == supertype(typeof(rr_eqs))
    end
    @testset "Scenarios" begin
        @test DICE.assign_scenario(BasePrice, vanilla_opt, vanilla_params) == vanilla_params.cpricebase
        vanilla_optimal_price = DICE.assign_scenario(OptimalPrice, vanilla_opt, vanilla_params);
        @test all(x->(vanilla_optimal_price[x] ≈ 1000.0), Int(vanilla_opt.tnopol+1):vanilla_opt.N)
        # Needs CPRICE, so requires a successful model run to test.
        DICE.assign_scenario(BasePrice, rr_opt, rr_params, rr_vars);
        @test_broken all(isfinite.(JuMP.getupperbound(rr_vars.CPRICE)))
        DICE.assign_scenario(OptimalPrice, rr_opt, rr_params, rr_vars);
        @test JuMP.getupperbound(rr_vars.μ[1]) == rr_opt.μ₀
        DICE.assign_scenario(Limit2Degrees, rr_opt, rr_params, rr_vars);
        @test JuMP.getupperbound(rr_vars.Tₐₜ[1]) ≈ 2.0
        DICE.assign_scenario(Stern, rr_opt, rr_params, rr_vars);
        @test JuMP.getvalue(rr_params.α) ≈ 1.01
        DICE.assign_scenario(SternCalibrated, rr_opt, rr_params, rr_vars);
        @test JuMP.getvalue(rr_params.α) ≈ 2.1
        DICE.assign_scenario(Copenhagen, rr_opt, rr_params, rr_vars);
        @test JuMP.getvalue(rr_params.partfract[2]) ≈ 0.390423082
        @test JuMP.getlowerbound(rr_vars.μ[3]) ≈ 0.110937151
        @test JuMP.getupperbound(rr_vars.μ[3]) ≈ 0.110937151
    end
    @testset "Invalid Vanilla Scenarios" begin
        @test_throws ErrorException solve(Limit2Degrees, v2013R())
        @test_throws ErrorException solve(Stern, v2013R())
        @test_throws ErrorException solve(SternCalibrated, v2013R())
        @test_throws ErrorException solve(Copenhagen, v2013R())
    end
end

# Optimisation tests.
# Currently, for some unknown reason, we cannot solve these
# tests in the travis environment. They become unfeaseable or
# hit some type of resource limit.
if get(ENV, "TRAVIS", "false") == "false"
    @testset "Utility" begin
        @testset "Vanilla" begin
            baserun = solve(BasePrice, v2013R());
            optimalrun = solve(OptimalPrice, v2013R());

            @test baserun.results.UTILITY ≈ 2670.2779245830334
            @test optimalrun.results.UTILITY ≈ 2690.244712873159
        end
    end
end
