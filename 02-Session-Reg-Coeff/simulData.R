muSBP <- seq(110, 130, by = 5)
sdSBP <- rep(2, 5)
muGLU <- seq(85, 125, by = 10)
sdGLU <- rep(4, 5)
ageg <- 1:5

newdata <- do.call(rbind,
    Map(function(mu1, mu2, sd1, sd2, ageg) {
        samples = 400
        r = 0.75
        mu <- c(mu1, mu2)
        stdev <- c(sd1, sd2)
        corMat <- matrix(c(1,r,r,1),nrow = 2)
        covMat <- stdev %*% t(stdev) * corMat
        data <- MASS::mvrnorm(n=samples, mu=mu, Sigma = covMat, empirical = FALSE)
        colnames(data) <- c("SBP", "GLU")
        data.frame(data, agegroup = ageg)
    }, mu1 = muSBP, mu2 = muGLU, sd1 = sdSBP, sd2 = sdGLU, ageg = ageg)
)

ages <- c("[20,29)", "[30,39)", "[40,49)", "[50,59)", "[60-69]")
newdata$agegroup <- factor(newdata$agegroup, levels = 1:5, labels = ages)

png(filename = "simulreg.png")
plot(newdata$GLU, newdata$SBP,
    xlab = "Fasting Glucose (mg/dL)",
    ylab = "Systolic Blood Pressure (mmHg)"
)
abline(lm(SBP ~ GLU, data = newdata), col = "red", lwd = 3)
dev.off()


png(filename = "simuldata-regs1.png")
plot(newdata$GLU, newdata$SBP, col = alpha(as.numeric(newdata$agegroup), 0.4),
    xlab = "Fasting Glucose (mg/dL)",
    ylab = "Systolic Blood Pressure (mmHg)"
)
for(i in seq_along(ages)) {
    yseq <- seq(120, 130, length.out = 5)[i]
    text(x = 86, y = yseq, ages[i])
    segments(x0 = 80, x1 = 82, y0 = yseq, y1 = yseq, col = seq(1, 5)[i], lwd = 2)
}
text(x = 85, y = 132, "Age Group", font = 2)
dev.off()


png(filename = "simuldata-regs2.png")
plot(newdata$GLU, newdata$SBP, col = alpha(as.numeric(newdata$agegroup), 0.4),
    xlab = "Fasting Glucose (mg/dL)",
    ylab = "Systolic Blood Pressure (mmHg)"
)
lapply(split(newdata, newdata$agegroup), function(x)
    TeachingDemos::clipplot(
        abline(lm(SBP ~ GLU, data = x), col = x$agegroup, lwd = 3),
        xlim = range(x$GLU)
    )
)
for(i in seq_along(ages)) {
    yseq <- seq(120, 130, length.out = 5)[i]
    text(x = 86, y = yseq, ages[i])
    segments(x0 = 80, x1 = 82, y0 = yseq, y1 = yseq, col = seq(1, 5)[i], lwd = 2)
}
text(x = 85, y = 132, "Age Group", font = 2)
dev.off()


## coefs

lapply(split(newdata, newdata$agegroup), function(x)
        coef(lm(SBP ~ GLU, data = x))
)
